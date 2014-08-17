library int_point;

class IntPoint {
  int x;
  int y;

  IntPoint(int x, int y) {
    this.x = x;
    this.y = y;
  }

  toString() => "($x,$y)";
}
