import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mathgame/src/core/app_constant.dart';
import 'package:mathgame/src/core/time_constant.dart';
import 'package:mathgame/src/data/models/correct_answer.dart';

import '../common/game_view_model.dart';

class CorrectAnswerProvider
    with ChangeNotifier
    implements GameAccess<CorrectAnswer> {
  GameViewModelImp gameViewModel;

  String _result;

  String get result => _result;

  int _time;

  int get time => _time;

  bool _pause = false;

  bool get pause => _pause;

  CorrectAnswer _currentState;

  CorrectAnswer get currentState => _currentState;

  double _currentScore = 0;

  double get currentScore => _currentScore;
  bool _timeOut;

  CorrectAnswerProvider() {
    gameViewModel = GameViewModelImp<CorrectAnswer>(
        gameAccess: this, gameCategoryType: GameCategoryType.CORRECT_ANSWER);
    startGame1();
  }

  @override
  void startGame1() {
    _time = TimeUtil.calculatorTimeOut;
    _timeOut = false;
    _result = "";
    _currentScore = 0;
    gameViewModel.startGame();
  }

  Future<void> checkResult(String answer) async {
    if (_result.length < currentState.answer.toString().length && !_timeOut) {
      _result = answer;
      notifyListeners();
      if (int.parse(_result) == currentState.answer) {
        await Future.delayed(Duration(milliseconds: 300));
        gameViewModel.loadNewDataIfRequired();
        _result = "";
        _time = TimeUtil.correctAnswerTimeOut;
        if (!_timeOut) {
          gameViewModel.restartGame();
        }
        notifyListeners();
      } else if (_result.length == currentState.answer.toString().length) {
        gameViewModel.wrongAnswer();
        _result = "";
      }
    }
  }

  clear() {
    _result = "";
    notifyListeners();
  }

  void showInfoDialog() {
    _pause = true;
    gameViewModel.pauseGame();
    gameViewModel.showInfoDialog();
  }

  void pauseTimer() {
    _pause = true;
    gameViewModel.pauseGame();
    notifyListeners();
    gameViewModel.showPauseGameDialog();
  }

  @override
  void onGameTimeOut() {
    this._timeOut = true;
  }

  @override
  void onGameTimeUpdate(int time) {
    _time = time;
    notifyListeners();
  }

  @override
  void onCurrentStateUpdate(CorrectAnswer currentState) {
    _currentState = currentState;
    notifyListeners();
  }

  @override
  void onScoreUpdate(double time) {
    _currentScore = time;
    notifyListeners();
  }

  @override
  void onResumeGame() {
    _pause = false;
    notifyListeners();
  }

  void dispose() {
    super.dispose();
    gameViewModel.exitGame();
  }
}
