import 'package:persistent/persistent_map.dart';
import 'package:test/test.dart';

void main() {
  test('test empty', () {
    var map = PersistentMap<String>();
    expect(() => map.get(0), throwsA(const TypeMatcher<Exception>()));
  });

  test('test 1 set get', () {
    var map = PersistentMap<String>();
    map = map.set(0, 'hello');
    expect(map.get(0), 'hello');
  });

  test('test small set get 1', () {
    var map = PersistentMap<String>();
    map = map.set(10, 'hello');
    expect(map.get(10), 'hello');
  });

  test('test small set get 2', () {
    var map = PersistentMap<String>();
    map = map.set(10, 'hello');
    map = map.set(11, 'world');
    expect(map.get(11), 'world');
  });

  test('test small set overwrite', () {
    var map = PersistentMap<String>();
    map = map.set(10, 'hello');
    map = map.set(10, 'world');
    expect(map.get(10), 'world');
  });

  test('test large set get', () {
    var map = PersistentMap<String>();
    map = map.set(100, 'hello');
    expect(map.get(100), 'hello');
  });

  test('test for each', () {
    var map = PersistentMap<String>();
    map = map.set(0, 'hello');
    map = map.set(1, 'world');
    map = map.set(2, 'I');
    map = map.set(3, 'love');
    map = map.set(4, 'you');
    var concat = '';
    var tally = 0;
    map.forEach((int idx, String value) {
      concat = concat + value + ' ';
      tally += idx;
    });
    expect(concat, 'hello world I love you ');
    expect(tally, 10);
  });

  test('test for each large', () {
    var map = PersistentMap<String>();
    var setIdx = 33;
    map = map.set(setIdx, 'hello');
    expect(map.get(setIdx), 'hello');
    var tally = 0;
    map.forEach((int idx, String value) {
      expect(idx, setIdx);
      expect(value, 'hello');
      tally += 1;
    });
    expect(tally, 1);
  });

  test('test for each random', () {
    var map = PersistentMap<String>();
    map = map.set(10, 'hello');
    map = map.set(20, 'world');
    map = map.set(30, 'I');
    map = map.set(40, 'love');
    map = map.set(50, 'you');
    var results = <int, String>{};
    map.forEach((int idx, String value) {
      results[idx] = value;
    });
    expect(results.length, 5);
    expect(results[10], 'hello');
    expect(results[20], 'world');
    expect(results[30], 'I');
    expect(results[40], 'love');
    expect(results[50], 'you');
  });

  test('fill', () {
    var map = PersistentMap<String>();
    for (var i = 0; i < 100; ++i) {
      var tally = 0;
      map.forEach((int idx, String value) {
        tally += 1;
      });
      expect(tally, i);
      map = map.set(i, '');
    }
  });

  test('values', () {
    var map = PersistentMap<String>();
    map = map.set(10, 'hello');
    map = map.set(20, 'world');
    map = map.set(30, 'I');
    map = map.set(40, 'love');
    map = map.set(50, 'you');
    expect(map.values.toList(), ['hello', 'world', 'I', 'love', 'you']);
  });
}
