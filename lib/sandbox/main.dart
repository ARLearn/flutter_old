import 'dart:async';
import 'dart:io';

class ThrottleFilter<T> {
  DateTime lastEventDateTime = null;
  final Duration duration;

  ThrottleFilter(this.duration);

  bool call(T e) {
    final now = new DateTime.now();
    if (lastEventDateTime == null ||
        now.difference(lastEventDateTime) > duration) {
      lastEventDateTime = now;
      return true;
    }
    return false;
  }
}

main() async {
  print('Hello, World!');
  
  var counterStream =
  Stream<int>.periodic(Duration(seconds: 1), (x) => x)
      .where(new ThrottleFilter<int>(const Duration(seconds: 3)).call)
      .expand((v) => new List(v).map((_)=>v))
  ;
  
  counterStream.forEach(print);
  

}