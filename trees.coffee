class Node
  data: null
  left: null
  right: null

  constructor: (data) ->
    @data = data

class VisualNode extends Node
  @diam: 30
  @counter: 0
  x: null
  y: null

  init: (depth) ->
    if @data.left isnt null
      @left = new VisualNode @data.left
      @left.init depth + 1

    @x = @constructor.counter * 20 + 20
    @y = depth * 50 + 20
    @constructor.counter++

    if @data.right isnt null
      @right = new VisualNode @data.right
      @right.init depth + 1

  draw: (ctx) ->
    ctx.strokeStyle = 'black'
    ctx.beginPath()
    offset = 10
    ctx.moveTo @x - offset, @y - offset
    ctx.lineTo @x + offset, @y + offset
    ctx.moveTo @x + offset, @y - offset
    ctx.lineTo @x - offset, @y + offset
    ctx.stroke()
    ctx.closePath()

class Trees
  canvas: null
  ctx: null
  tickMs: 33
  width: 640
  height: 480
  root: null

  constructor: ->
    @canvas = document.getElementById 'treescanvas'
    @width = @canvas.width
    @height = @canvas.height
    @ctx = @canvas.getContext '2d'

    root = new Node 5
    root.left = new Node 3
    root.right = new Node 7
    root.left.left = new Node 2
    root.left.right = new Node 4
    root.right.left = new Node 6
    root.right.right = new Node 8

    @root = new VisualNode root
    @root.init 0

    @draw()

  draw: ->
    @clear()
    @ctx.lineWidth = 1
    @drawLink @root
    @drawNode @root

  drawLink: (node) ->
    return if node is null

    if node.left isnt null
      @drawLine 'black', node.x, node.y, node.left.x, node.left.y
      @drawLink node.left

    if node.right isnt null
      @drawLine 'black', node.x, node.y, node.right.x, node.right.y
      @drawLink node.right

  drawNode: (node) ->
    return if node is null
    @drawNode node.left
    node.draw @ctx
    @drawNode node.right

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
