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
    @clear()

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

  parse: (str) ->
    len = str.length
    numLeftParens = 0
    numRightParens = 0
    for i in [0...len]
      ch = str.charAt i
      if ch is '('
        numLeftParens++
      else if ch is ')'
        numRightParens++
      else if numLeftParens == numRightParens
        start = i
        while ch isnt '(' and ch isnt ')' and i < len
          ch = str.charAt ++i
        end = i
        rootText = str.substring start, end
        root = new Node rootText
        if start isnt 0 and end isnt len
          leftText = str.substring 1, start - 1
          rightText = str.substring end + 1, len - 1
          root.left = @parse leftText
          root.right = @parse rightText
        return root
    null

  update: (input) ->
    VisualNode.counter = 0

    # Remove all whitespace
    input = input.replace /\s/g, ''

    root = @parse input

    if root is null
      @root = null
    else
      @root = new VisualNode root
      @root.init 0

    @draw()

window.onload = ->
  trees = new Trees
  document.getElementById('updatebutton').onclick = ->
    inputField = document.getElementById 'inputfield'
    trees.update inputField.value
