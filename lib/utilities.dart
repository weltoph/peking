import 'dart:math';

Random _random = Random();

List<T> choose<T>(List<T> from, int many) {
  assert(many <= from.length);
  List<int> indices = List.generate(from.length, (index) => index);
  List<T> result = List.empty(growable: true);
  for(int i = 0; i < many; i++) {
    int pick = _random.nextInt(from.length - i);
    result.add(from[indices.removeAt(pick)]);
  }
  return result;
}

T pick<T>(List<T> from) {
  assert(from.isNotEmpty);
  List<T> result = choose(from, 1);
  assert(result.length == 1);
  return result[0];
}

List<T> permutation<T>(List<T> from) {
  List<T> result = choose(from, from.length);
  assert(result.length == from.length);
  return result;
}