import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:youplay/actions/games.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:youplay/actions/actions.dart';
import 'package:youplay/api/account.dart';
import 'package:youplay/store/state/app_state.dart';
import 'package:youplay/store/actions/auth.actions.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

AppleSignIn _appleSignIn = AppleSignIn();

//Epics

final authLoginGoogleEpic = new TypedEpic<AppState, GoogleLoginAction>(googleLogin);
final authLoginAppleEpic = new TypedEpic<AppState, AppleLoginAction>(appleLogin);
final authLogoutEpic = new TypedEpic<AppState, SignOutAction>(signOut);

final loadAppleCredentials = new TypedEpic<AppState, AppleLoginSucceededAction>(loadCredentials);
final loadGoogleCredentials =
    new TypedEpic<AppState, GoogleLoginSucceededAction>(loadGoogleAccountDetails);

Stream<dynamic> loadCredentials(
  Stream<AppleLoginSucceededAction> actions,
  EpicStore<AppState> store,
) {
  return actions.where((action) => action is AppleLoginSucceededAction)
      .asyncMap((action) async {
    await AccountApi.accountDetails();
    return null;
  });
}

Stream<dynamic> loadGoogleAccountDetails(
  Stream<GoogleLoginSucceededAction> actions,
  EpicStore<AppState> store,
) {
  return actions.where((action) => action is GoogleLoginSucceededAction)
      .asyncMap((action) async {
    await AccountApi.accountDetails();
    return null;
  });
}

Stream<dynamic> googleLogin(
  Stream<GoogleLoginAction> actions,
  EpicStore<AppState> store,
) {
  return actions.asyncMap((action) => _googleSignIn.signIn().then((gUser) => (gUser == null)
      ? action.onError()
      : gUser.authentication.then((googleAuth) => _auth
          .signInWithCredential(GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ))
          .then((authResult) => authResult.user.getIdToken().then((token) {
                if (action.onSucces != null) {
                  action.onSucces();
                }
                return new GoogleLoginSucceededAction(
                    authResult.user.displayName, authResult.user.email);
              })))));
}

Stream<dynamic> appleLogin(
  Stream<AppleLoginAction> actions,
  EpicStore<AppState> store,
) {
  return actions.asyncMap((action) async {
    try {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          try {
            print("successfull sign in");
            final AppleIdCredential appleIdCredential = result.credential;

            OAuthProvider oAuthProvider = new OAuthProvider(providerId: "apple.com");
            final AuthCredential credential = oAuthProvider.getCredential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken),
              accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
            );

            final AuthResult _res = await FirebaseAuth.instance.signInWithCredential(credential);

            FirebaseUser user = await FirebaseAuth.instance.currentUser();
            if (action.onSucces != null) {
              action.onSucces();
            }
            return new AppleLoginSucceededAction(user.displayName, user.email);

            // FirebaseAuth.instance.currentUser().then((val) async {
            //   UserUpdateInfo updateUser = UserUpdateInfo();
            //   updateUser.displayName =
            //   "${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}";
            //   updateUser.photoUrl =
            //   "define an url";
            //   await val.updateProfile(updateUser);
            // });

          } catch (e) {
            print("error");
          }
          break;
        case AuthorizationStatus.error:
          // do something
          action.onError("something went wrong");
          break;

        case AuthorizationStatus.cancelled:
          action.onError("Inloggen afgebroken door gebruiker");
          break;
      }
    } catch (error) {
      action.onError("something went wrong");
    }
  });
}

Stream<dynamic> signOut(
  Stream<SignOutAction> actions,
  EpicStore<AppState> store,
) {
  return actions.asyncMap((action) {
    FirebaseAuth.instance.signOut().then((value) {
      print("sign out result ");
    });
//    try {
//      _googleSignIn.isSignedIn().then((isActive) {
//        if (isActive) _googleSignIn.disconnect();
//      });
//    } catch (error) {
//      print(error);
//    }
    return null;
  });
}
