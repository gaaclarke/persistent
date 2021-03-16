import 'dart:collection';

import 'package:persistent/persistent.dart';

void main() {
  final count = 100000;
  {
    var list = PersistentList<int>();
    var start = DateTime.now();
    for (var i = 0; i < count; ++i) {
      list = list.add(i);
    }
    var duration = DateTime.now().difference(start);
    print('add test PersistentList: ${duration.inMicroseconds / count} us');
  }

  {
    var list = <int>[];
    var start = DateTime.now();
    for (var i = 0; i < count; ++i) {
      list.add(i);
    }
    var duration = DateTime.now().difference(start);
    print('add test List: ${duration.inMicroseconds / count} us');
  }

  {
    var list = HashMap();
    var start = DateTime.now();
    for (var i = 0; i < count; ++i) {
      list.putIfAbsent(i, () => i);
    }
    var duration = DateTime.now().difference(start);
    print('add test Hash: ${duration.inMicroseconds / count} us');
  }

  {
    var list = PersistentList<int>();
    list = list.add(0);
    var tally = 0;
    var start = DateTime.now();
    for (var i = 0; i < count; ++i) {
      tally += list[0];
    }
    var duration = DateTime.now().difference(start);
    print('get test PersistentList: ${duration.inMicroseconds / count} us ($tally)');
  }

  {
    var list = <int>[];
    list.add(0);
    var tally = 0;
    var start = DateTime.now();
    for (var i = 0; i < count; ++i) {
      tally += list[0];
    }
    var duration = DateTime.now().difference(start);
    print('get test List: ${duration.inMicroseconds / count} us ($tally)');
  }

  {
    var list = HashMap<int, int>();
    list.putIfAbsent(0, () => 0);
    var tally = 0;
    var start = DateTime.now();
    for (var i = 0; i < count; ++i) {
      tally += list[0]!;
    }
    var duration = DateTime.now().difference(start);
    print('get test Hash: ${duration.inMicroseconds / count} us ($tally)');
  }

  {
    var list = PersistentList<int>.from(Iterable.generate(count));
    var tally = 0;
    var start = DateTime.now();
    for (var x in list.iterable) {
      tally += x;
    }
    var duration = DateTime.now().difference(start);
    print('iterate test PersistentList: ${duration.inMicroseconds / count} us ($tally)');
  }

  {
    var list = List<int>.from(Iterable.generate(count));
    var tally = 0;
    var start = DateTime.now();
    for (var x in list) {
      tally += x;
    }
    var duration = DateTime.now().difference(start);
    print('iterate test List: ${duration.inMicroseconds / count} us ($tally)');
  }

  {
    var list = HashMap<int, int>();
    for(var i = 0; i < count; ++i) {
      list.putIfAbsent(i, () => i);
    }
    var tally = 0;
    var start = DateTime.now();
    for (var x in list.values) {
      tally += x;
    }
    var duration = DateTime.now().difference(start);
    print('iterate test Hash: ${duration.inMicroseconds / count} us ($tally)');
  }
}
