import 'package:persistent/persistent_list.dart';
import 'package:test/test.dart';

void main() {
  test('test empty', () {
    var list = PersistentList<String>();
    expect(() => list[0], throwsA(const TypeMatcher<Exception>()));
  });

  test('test filled', () {
    var list = PersistentList<String>.filled(100, 'hello');
    expect(list.count, 100);
    expect(list[1], 'hello');
  });

  test('test add', () {
    var list = PersistentList<String>.filled(100, 'hello');
    list = list.add('world');
    expect(list.count, 101);
    expect(list[100], 'world');
  });

  test('from', () {
    var list = PersistentList<int>.from(Iterable.generate(10));
    expect(list.iterable.toList(), Iterable.generate(10).toList());
  });
}
