library random_walk;

import 'dart:html';

import 'int_point.dart';
import 'random_util.dart';
import 'random_walk_renderer.dart';
import 'dart:async';

abstract class RandomWalk {
  int _repetitions;
  bool _showMovements;
  List<Function> _movements;
  RandomUtil _randomUtil;
  IntPoint _position;
  RandomWalkRenderer _renderer;

  RandomWalk({int repetitions:100, bool showMovements:false, int granularity:100}) {
    this._repetitions = repetitions;
    this._showMovements = showMovements;
    this._position = new IntPoint(0, 0);
    this._randomUtil = new RandomUtil<Function>();
    this._movements = this._getMovements();
    if (_showMovements) {
      this._renderer = new RandomWalkRenderer(is2D(), granularity:granularity);
      _renderer.walkTo(_position);
    }
  }

  static RandomWalk fromInt(int number, {int repetitions:100, bool showMovements:false, int granularity:100}) {
    switch (number) {
      case 0: return new Normal1DWalk(repetitions: repetitions, showMovements: showMovements, granularity: granularity);
      case 1: return new Forward1DWalk(repetitions: repetitions, showMovements: showMovements, granularity: granularity);
      case 2: return new Unbalanced1DWalk(repetitions: repetitions, showMovements: showMovements, granularity: granularity);
      case 3: return new Normal2DWalk(repetitions: repetitions, showMovements: showMovements, granularity: granularity);
    }
  }

  bool is2D() {
    return false;
  }

  List<Function> _getMovements();
  void _goNext();

  void _updateDisplay() {
    _renderer.walkTo(_position);
  }

  getPosition() => _position;

  void _run(Function callback, int n) {
    if (n >= _repetitions) {
      callback();
      return;
    }
    _goNext();
    if (_showMovements) {
      _updateDisplay();
    }
    if (_showMovements) {
      new Future.delayed(const Duration(milliseconds: 100), () => _run(callback, n + 1));
    } else {
      _run(callback, n + 1);
    }
  }

  void run(Function callback) {
    _position = new IntPoint(0, 0);
    _run(callback, 0);
  }
}

class Normal1DWalk extends RandomWalk {
  Normal1DWalk({int repetitions:100, bool showMovements:false, int granularity:100}):
    super(repetitions: repetitions, showMovements: showMovements, granularity: granularity);

  List<Function> _getMovements() {
    return [
      () => _position.x += 1,
      () => _position.x -= 1,
    ];
  }

  void _goNext() {
    _randomUtil.pickFromTwo(_movements[0], _movements[1], 0.5)();
  }
}

class Forward1DWalk extends RandomWalk {
  Forward1DWalk({int repetitions:100, bool showMovements:false, int granularity:100}):
    super(repetitions: repetitions, showMovements: showMovements, granularity: granularity);

  List<Function> _getMovements() {
    return [
      () => _position.x += 1,
      () => _position.x
    ];
  }

  void _goNext() {
    _randomUtil.pickFromTwo(_movements[0], _movements[1], 0.5)();
  }
}

class Unbalanced1DWalk extends RandomWalk {
  Unbalanced1DWalk({int repetitions:100, bool showMovements:false, int granularity:100}):
    super(repetitions: repetitions, showMovements: showMovements, granularity: granularity);

  List<Function> _getMovements() {
    return [
      () => _position.x += 1,
      () => _position.x -= 1,
    ];
  }

  void _goNext() {
    _randomUtil.pickFromTwo(_movements[0], _movements[1], 0.99)();
  }
}

class Normal2DWalk extends RandomWalk {
  Normal2DWalk({int repetitions:100, bool showMovements:false, int granularity:100}):
    super(repetitions: repetitions, showMovements: showMovements, granularity: granularity);

  List<Function> _getMovements() {
    return [
      () => _position.x += 1,
      () => _position.x -= 1,
      () => _position.y += 1,
      () => _position.y -= 1,
    ];
  }

  void _goNext() {
    _randomUtil.pickFromList(_movements)();
  }

  bool is2D() {
    return true;
  }
}
