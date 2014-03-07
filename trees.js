// Generated by CoffeeScript 1.6.3
var Trees;

Trees = (function() {
  Trees.prototype.canvas = null;

  Trees.prototype.ctx = null;

  Trees.prototype.tickMs = 33;

  Trees.prototype.width = 640;

  Trees.prototype.height = 480;

  function Trees() {
    this.canvas = document.getElementById('treescanvas');
    this.width = this.canvas.width;
    this.height = this.canvas.height;
    this.ctx = this.canvas.getContext('2d');
    this.draw();
  }

  Trees.prototype.draw = function() {
    this.clear();
    return this.drawBackground();
  };

  Trees.prototype.drawBackground = function() {
    return this.ctx.lineWidth = 1;
  };

  Trees.prototype.drawLine = function(color, x1, y1, x2, y2) {
    this.ctx.strokeStyle = color;
    this.ctx.beginPath();
    this.ctx.moveTo(x1, y1);
    this.ctx.lineTo(x2, y2);
    this.ctx.stroke();
    return this.ctx.closePath();
  };

  Trees.prototype.clear = function() {
    this.ctx.fillStyle = 'white';
    return this.ctx.fillRect(0, 0, this.width, this.height);
  };

  return Trees;

})();