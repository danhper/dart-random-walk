library simulator;

import 'dart:html';

import 'random_walk.dart';
import 'random_walk_renderer.dart';
import 'int_point.dart';

class Simulator {
  bool _running;
  RandomWalk _simulation;
  Map<int, List<IntPoint>> _results;

  Simulator() {
    this._running = false;
    querySelector("#run-simulation").onClick.listen(_runSimulation);
    _results = new Map();
    for (int i = 0; i < 4; i++) {
      _results[i] = [];
    }
  }

  void _runSimulation(event) {
    if (this._running) {
      return;
    }
    this._running = true;
    InputElement typeSelect = querySelector("#walk-type");
    InputElement showAnimation = querySelector("#animate-walk");
    bool animate = (querySelector("#animate-walk") as InputElement).checked;
    int simulationType = int.parse(typeSelect.value);
    _simulation = RandomWalk.fromInt(simulationType, showMovements: animate);
    if (animate) {
      querySelector("#result-wrapper").hidden = true;
      (querySelector("#run-num") as InputElement).value = "1";
      _simulation.run(() => _finalize(simulationType));
    } else {
      InputElement runInput = querySelector("#run-num");
      int runTimes = int.parse(runInput.value, onError: (s) => 1);
      if (runTimes <= 0) runTimes = 1;
      runInput.value = runTimes.toString();
      for (int i = 0; i < runTimes - 1; i++) {
        _simulation.run(() => _finalize(simulationType, showResults: false));
      }
      _simulation.run(() => _finalize(simulationType));
    }
  }

  void _finalize(int type, {bool showResults: true}) {
    _results[type].add(_simulation.getPosition());
    if (!showResults) {
      return;
    }

    _running = false;
    Element result = querySelector("#result");
    if (_simulation.is2D()) {
      result.text = _simulation.getPosition().toString();
    } else {
      String x = _simulation.getPosition().x.toString();
      result.text = "x = $x";
    }
    querySelector("#result-wrapper").hidden = false;
    _showResults();
  }

  IntPoint _getAverage(List<IntPoint> points) {
    int totalX = 0, totalY = 0;
    for (var point in points) {
      totalX += point.x;
      totalY += point.y;
    }
    return new IntPoint((totalX / points.length).round(), (totalY / points.length).round());
  }

  void _showResults() {
    for (var i = 0; i < 4; i++) {
      String text;
      var results = _results[i];
      if (results.length == 0) {
        text = 'NA';
      } else {
        IntPoint avg = _getAverage(results);
        text = i == 3 ? avg.toString() : avg.x.toString();
        text += "(" + results.length.toString() + "実行)";
      }
      querySelector("#result-$i").text = text;
    }
  }
}

void enableDisable(event) {
  bool animate = (querySelector("#animate-walk") as InputElement).checked;
  (querySelector("#run-num") as InputElement).disabled = animate;
}

void main() {
  querySelector("#result-wrapper").hidden = true;
  (querySelector("#run-num") as InputElement).disabled = true;
  querySelector("#animate-walk").onChange.listen(enableDisable);
  new RandomWalkRenderer(false, granularity:100);
  new Simulator();
}
