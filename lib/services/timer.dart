import 'dart:async';
void startTimer(int hour) {
  int  _counter = 10;

  Timer.periodic(Duration(seconds: 1), (Timer t) {
    if (_counter > 0) {
      _counter--;
      print(_counter);
      print("Time ache");
    } else {
      print("Time Ses");
      t.cancel();
    }

  });
}
