import 'persistent_map.dart';

PersistentMap<T> _filled<T>(int count, T value) {
  var result = PersistentMap<T>();
  for (var i = 0; i < count; ++i) {
    result = result.set(i, value);
  }
  return result;
}

class PersistentList<T> {
  final PersistentMap<T> _map;
  final int count;
  static const maxSize = PersistentMap.maxSize;

  PersistentList()
      : _map = PersistentMap<T>(),
        count = 0;

  PersistentList.filled(int count, T value)
      : _map = _filled(count, value),
        count = count;

  factory PersistentList.from(Iterable<T> iterable) {
    var map = PersistentMap<T>();
    var count = 0;
    for (var value in iterable) {
      map = map.set(count++, value);
    }
    return PersistentList._(map, count);
  }

  PersistentList._(PersistentMap<T> map, int count)
      : _map = map,
        count = count;

  T operator [](int idx) {
    return _map.get(idx);
  }

  PersistentList<T> set(int idx, T value) {
    return PersistentList._(_map.set(idx, value), count);
  }

  PersistentList<T> add(T value) {
    return PersistentList._(_map.set(count, value), count + 1);
  }

  Iterable<T> get iterable {
    return _map.values;
  }
}
