library random_util;

import 'dart:math';

class RandomUtil<T> {
  Random random;

  RandomUtil() {
    this.random = new Random();
  }

  T pickFromTwo(T a, T b, double aProb) {
    return this.random.nextDouble() >= aProb ? b : a;
  }

  T pickFromList(List<T> list) {
    return list[this.random.nextInt(list.length)];
  }
}
