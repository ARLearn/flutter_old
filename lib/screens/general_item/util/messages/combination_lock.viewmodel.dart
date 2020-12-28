import 'package:redux/redux.dart';
import 'package:youplay/models/run.dart';
import 'package:youplay/screens/general_item/util/messages/components/themed_app_bar.viewmodel.dart';
import 'package:youplay/selectors/ui_selectors.dart';
import 'package:youplay/store/selectors/current_run.selectors.dart';
import 'package:youplay/store/selectors/game_messages.selector.dart';
import 'package:youplay/store/state/app_state.dart';
import 'package:youplay/models/game.dart';
import 'package:youplay/state/ui_state.dart';
import 'package:youplay/store/actions/ui_actions.dart';
import 'package:youplay/store/selectors/current_game.selectors.dart';




class CombinationLockViewModel {
  bool correctAnswerGiven;

  CombinationLockViewModel({this.correctAnswerGiven,
      });

  static CombinationLockViewModel fromStore(Store<AppState> store) {

    return new CombinationLockViewModel(
        correctAnswerGiven: correctAnswerGivenSelector(store.state),
    );
  }
}
