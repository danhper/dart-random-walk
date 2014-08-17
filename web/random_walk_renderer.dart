library random_walk_drawer;

import 'dart:html';
import 'int_point.dart';

class RandomWalkRenderer {
  CanvasElement _canvas;
  CanvasRenderingContext2D _ctx;

  int _width;
  int _height;
  int _center;
  int _middle;

  int _granularity;

  IntPoint _position;

  RandomWalkRenderer(bool drawHorizontalTicks, {int granularity:100}) {
    this._canvas = querySelector("#random-walk-canvas");
    this._ctx = _canvas.context2D;
    this._width = _canvas.width;
    this._height = _canvas.height;
    this._center = (_width / 2).toInt();
    this._middle = (_height / 2).toInt();
    this._granularity = granularity;
    this._position = new IntPoint(0, 0);
    this._prepareCanvas(drawHorizontalTicks);

    _ctx.fillStyle = 'red';
  }

  void walkTo(IntPoint position) {
    _ctx.clearRect(_position.x + 1, _position.y - 4, 3, 3);
    int x = (position.x * _width / (_granularity * 2)).toInt() + _center;
    int y = (_middle - position.y * _height / _granularity * 2).toInt();
    _position = new IntPoint(x, y);
    _ctx.fillRect(_position.x + 1, _position.y - 4, 3, 3);
  }

  void _prepareCanvas(bool drawHorizontalTicks) {
    _ctx.clearRect(0, 0, _width, _height);
    _drawSurrounding();
    _drawCenterLines();
    _drawVerticalTicks();
    if (drawHorizontalTicks) {
      _drawHorizontalTicks();
    }
  }

  void _drawSurrounding() {
    _ctx.beginPath();
    _ctx.moveTo(0, 0);
    _ctx.lineTo(_width, 0);
    _ctx.lineTo(_width, _height);
    _ctx.lineTo(0, _height);
    _ctx.lineTo(0, 0);
    _ctx.stroke();
    _ctx.closePath();
  }

  void _drawCenterLines() {
    _ctx.beginPath();
    _ctx.moveTo(0, _middle);
    _ctx.lineTo(_width, _middle);
    _ctx.moveTo(_center, 0);
    _ctx.lineTo(_center, _height);
    _ctx.stroke();
    _ctx.closePath();
  }

  void _drawVerticalTicks() {
    _ctx.beginPath();
    for (var i = 0; i < _width; i += _width / (_granularity * 2)) {
      _ctx.moveTo(i, _middle);
      _ctx.lineTo(i, _middle - 5);
    }
    _ctx.stroke();
    _ctx.closePath();
  }

  void _drawHorizontalTicks() {
    _ctx.beginPath();
    for (var i = 0; i < _height; i += _height / _granularity) {
      _ctx.moveTo(_center, i);
      _ctx.lineTo(_center + 5, i);
    }
    _ctx.stroke();
    _ctx.closePath();
  }
}
