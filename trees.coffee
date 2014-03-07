class Node
  data: null
  left: null
  right: null

  constructor: (data) ->
    @data = data

class VisualNode extends Node
  @diam: 32
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
    # Draw circle
    ctx.fillStyle = 'green'
    ctx.strokeStyle = 'black'
    ctx.lineWidth = 2
    ctx.beginPath()
    ctx.arc @x, @y, @constructor.diam/2, 0, 2 * Math.PI, false
    ctx.fill()
    ctx.stroke()
    ctx.closePath()

    # Draw text
    ctx.font = @getFont 10
    ctx.fillStyle = 'black'
    ctx.textAlign = 'center'
    ctx.fillText @data.data, @x, @y + 4

  getFont: (size) ->
    size + 'pt Calibri'

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

  parse: (input) ->
    root = new Node 637
    root.left = new Node 72
    root.right = new Node 903
    root.left.left = new Node 8
    root.left.right = new Node 95
    root.right.left = new Node 750
    root.right.right = new Node 5000
    root

  update: (input) ->
    VisualNode.counter = 0

    @root = new VisualNode (@parse input)
    @root.init 0

    @draw()

window.onload = ->
  trees = new Trees
  document.getElementById('updatebutton').onclick = ->
    inputField = document.getElementById 'inputfield'
    trees.update inputField.innerHTML
