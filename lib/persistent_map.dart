import 'dart:collection' show Queue;

const int _mask = 0x1f;
const int _maskSize = 5;
const int _maxDepth = 6;

abstract class _Node<T> {}

class _Leaf<T> implements _Node<T> {
  final T value;
  _Leaf(this.value);
}

class _Trie<T> implements _Node<T> {
  final List<_Node<T>?> children;
  static const childrenCount = 1 << _maskSize;

  static List<_Node<T>?> makeOneChildren<T>(int idx, _Node<T>? value) {
    assert(idx < childrenCount);
    var tempChildren = List<_Node<T>?>.filled(childrenCount, null);
    tempChildren[idx] = value;
    return tempChildren;
  }

  _Trie.one(int idx, _Node<T>? value) : children = makeOneChildren(idx, value);

  _Trie(List<_Node<T>?> children) : children = children {
    assert(this.children.length == childrenCount);
  }

  _Node<T>? set(int idx, _Node<T>? value) {
    assert(idx < childrenCount);
    var tempChildren = List<_Node<T>?>.from(children, growable: false);
    tempChildren[idx] = value;
    return _Trie(tempChildren);
  }
}

_Node<T>? _setter<T>(_Node<T>? root, int idx, T? value, int depth) {
  if (depth > _maxDepth) {
    if (value != null) {
      return _Leaf(value);
    } else {
      return null;
    }
  } else {
    var adjustedIdx = (idx >> ((_maxDepth - depth) * _maskSize)) & _mask;
    if (root == null) {
      return _Trie.one(adjustedIdx, _setter(null, idx, value, depth + 1));
    } else {
      var trie = root as _Trie<T>;
      return trie.set(adjustedIdx,
          _setter(trie.children[adjustedIdx], idx, value, depth + 1));
    }
  }
}

T _getter<T>(_Node<T>? root, int idx, int depth) {
  if (depth > _maxDepth) {
    if (root != null) {
      var leaf = root as _Leaf<T>;
      return leaf.value;
    } else {
      throw Exception('no item at $idx');
    }
  } else {
    if (root == null) {
      throw Exception('no item at $idx');
    } else {
      var adjustedIdx = (idx >> ((_maxDepth - depth) * _maskSize)) & _mask;
      var trie = root as _Trie<T>;
      final child = trie.children[adjustedIdx];
      return _getter(child, idx, depth + 1);
    }
  }
}

void _forEach<T>(_Node<T>? root, int idx, Function(int, T) forFunc) {
  if (root != null) {
    if (root is _Trie<T>) {
      var trie = root;
      for (var i = 0; i < _Trie.childrenCount; ++i) {
        var adjustedIdx = (idx << _maskSize) + i;
        _forEach(trie.children[i], adjustedIdx, forFunc);
      }
    } else {
      var leaf = root as _Leaf<T>;
      forFunc(idx, leaf.value);
    }
  }
}

void _debug<T>(_Node<T>? root, int indent, int prefix) {
  var indentString = '';
  for (var j = 0; j < indent; ++j) {
    indentString += '  ';
  }
  if (root != null) {
    if (root is _Trie<T>) {
      var trie = root;
      var indentString = '';
      for (var j = 0; j < indent; ++j) {
        indentString += '  ';
      }
      print('$indentString$prefix: {');
      for (var i = 0; i < _Trie.childrenCount; ++i) {
        _debug(trie.children[i], indent + 1, i);
      }
      print('$indentString}');
    } else {
      var leaf = root as _Leaf<T>;
      print('$indentString$prefix: ${leaf.value} ');
    }
  } else {
    print('$indentString$prefix: null');
  }
}

class PersistentMap<T> {
  final _Node<T>? _root;
  static const int maxSize = 1 << (_maxDepth + 1 * _maskSize);

  PersistentMap() : _root = null;
  PersistentMap._(_Node<T>? root) : _root = root;

  T get(int idx) {
    return _getter(_root, idx, 0);
  }

  PersistentMap<T> set(int idx, T value) {
    return PersistentMap._(_setter(_root, idx, value, 0));
  }

  PersistentMap<T> remove(int idx) {
    return PersistentMap._(_setter(_root, idx, null, 0));
  }

  void forEach(void Function(int, T) forFunc) {
    _forEach(_root, 0, forFunc);
  }

  void debug() {
    _debug(_root, 0, 0);
  }

  Iterable<T> get values sync* {
    var nodes = Queue<_Node<T>>();
    if (_root != null) {
      nodes.addLast(_root!);
    }
    while (nodes.isNotEmpty) {
      final node = nodes.removeFirst();
      if (node is _Leaf<T>) {
        yield node.value;
      } else if (node is _Trie<T>) {
        for (var i = 0; i < _Trie.childrenCount; ++i) {
          if (node.children[i] != null) {
            nodes.addLast(node.children[i]!);
          }
        }
      }
    }
  }
}
