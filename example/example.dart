import 'package:persistent/persistent.dart';

void main() {
  var list = PersistentList<int>.from(Iterable.generate(100));
  list = list.set(0, -1);
  var tally = 0;
  for (var x in list.iterable) {
    tally += x;
  }
  print(tally);
}
