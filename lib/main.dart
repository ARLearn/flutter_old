import 'package:youplay/arlearn_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:youplay/actions/actions.dart';
import 'package:youplay/models/models.dart';
import 'package:youplay/screens/pages/home_page.dart';
import 'package:youplay/selectors/selectors.dart';
//import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
//import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:youplay/epics/epics.dart';
import 'package:youplay/actions/games.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:youplay/selectors/ui_selectors.dart';

import 'dart:io';

import 'package:youplay/store/store.dart';

void main() async {
  final store = await createStore();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'arleu',
    options: FirebaseOptions(
      googleAppID: Platform.isIOS
          ? '1:7648734236ddae402a0'
          : '1:764858fc99d2e',
      gcmSenderID: '764873423698',
      apiKey: 'A',
      projectID: 'arle',
    ),
  );
  final FirebaseStorage storage =
      FirebaseStorage(app: app, storageBucket: 'gs://arle');
  store.state.storage = storage;
//  store.dispatch(new SetFirebaseStorage(storage: storage));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store,
        child: new MaterialApp(
          debugShowCheckedModeBanner:false,
          title: 'ARLEARN',
          theme: ThemeData(
            // Define the default Brightness and Colors
            brightness: Brightness.light,
            primaryColor: const Color(0xFFE2001A),
//            primaryColor: const Color(0xFF3EA3DC),
            primarySwatch: Colors.red,
//            primarySwatch: Colors.purple,
            accentColor: const Color(0xFFE2001A),
          ),
          home: new SplashScreen(),
        ));
  }
}
