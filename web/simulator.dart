library simulator;

import 'dart:html';

import 'random_walk.dart';
import 'random_walk_renderer.dart';

class Simulator {
  bool _running;
  RandomWalk _simulation;

  Simulator() {
    this._running = false;
    querySelector("#run-simulation").onClick.listen(_runSimulation);
  }

  void _runSimulation(event) {
    if (this._running) {
      return;
    }
    this._running = true;
    InputElement typeSelect = querySelector("#walk-type");
    InputElement showAnimation = querySelector("#animate-walk");
    bool animate = showAnimation.checked;
    if (animate) {
      querySelector("#result-wrapper").hidden = true;
    }
    _simulation = RandomWalk.fromInt(int.parse(typeSelect.value), showMovements: animate);
    _simulation.run(() => _finalize());
  }

  void _finalize() {
    _running = false;
    Element result = querySelector("#result");
    if (_simulation.is2D()) {
      result.text = _simulation.getPosition().toString();
    } else {
      String x = _simulation.getPosition().x.toString();
      result.text = "x = $x";
    }
    querySelector("#result-wrapper").hidden = false;
  }
}

void main() {
  new RandomWalkRenderer(false, granularity:100);
  new Simulator();
  querySelector("#result-wrapper").hidden = true;
}
