class Trees
  canvas: null
  ctx: null
  tickMs: 33
  width: 640
  height: 480

  constructor: ->
    @canvas = document.getElementById 'treescanvas'
    @width = @canvas.width
    @height = @canvas.height
    @ctx = @canvas.getContext '2d'

    @draw()

  draw: ->
    @clear()
    @drawBackground()

  drawBackground: ->
    @ctx.lineWidth = 1

  drawLine: (color, x1, y1, x2, y2) ->
    @ctx.strokeStyle = color
    @ctx.beginPath()
    @ctx.moveTo x1, y1
    @ctx.lineTo x2, y2
    @ctx.stroke()
    @ctx.closePath()

  clear: ->
    @ctx.fillStyle = 'white'
    @ctx.fillRect 0, 0, @width, @height
