class Node
  data: null
  left: null
  right: null

  constructor: (data) ->
    @data = data

class VisualNode extends Node
  @diam: 32
  @nodeColor: null
  @lineColor: null
  @textColor: null
  @margin: 20
  @counter: 0
  x: null
  y: null

  init: (depth) ->
    if @data.left isnt null
      @left = new VisualNode @data.left
      @left.init depth + 1

    @x = @constructor.counter * 20 + @constructor.margin
    @y = depth * 50 + @constructor.margin
    @constructor.counter++

    if @data.right isnt null
      @right = new VisualNode @data.right
      @right.init depth + 1

  draw: (ctx) ->
    @drawCircle ctx
    @drawText ctx

  drawCircle: (ctx) ->
    ctx.fillStyle = @constructor.nodeColor
    ctx.strokeStyle = @constructor.lineColor
    ctx.lineWidth = 2
    ctx.beginPath()
    ctx.arc @x, @y, @constructor.diam/2, 0, 2 * Math.PI, false
    ctx.fill()
    ctx.stroke()
    ctx.closePath()

  drawText: (ctx) ->
    ctx.font = @getFont 10
    ctx.fillStyle = @constructor.textColor
    ctx.textAlign = 'center'
    ctx.fillText @data.data, @x, @y + 4

  getFont: (size) ->
    size + 'pt Calibri'

class Trees
  @bgColor: null
  @lineColor: null
  canvas: null
  ctx: null
  root: null
  tickMs: 33
  width: 400
  height: 250

  constructor: ->
    @canvas = document.getElementById 'treescanvas'
    @restoreSize()
    @ctx = @canvas.getContext '2d'
    @clear()

  draw: ->
    @resize()
    @clear()
    @ctx.lineWidth = 1
    @drawLink @root
    @drawNode @root

  save: ->
    @canvas.toBlob (blob) -> saveAs blob, 'tree.png'

  drawLink: (node) ->
    return if node is null
    if node.left isnt null
      @drawLine @constructor.lineColor, node.x, node.y, node.left.x, node.left.y
      @drawLink node.left
    if node.right isnt null
      @drawLine @constructor.lineColor, node.x, node.y, node.right.x, node.right.y
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
    @ctx.fillStyle = @constructor.bgColor
    @ctx.fillRect 0, 0, @width, @height

  restoreSize: ->
    @canvas.width = @width
    @canvas.height = @height

  resize: ->
    @canvas.width = @getMaxX() + VisualNode.margin
    @canvas.height = @getMaxY() + VisualNode.margin

  getMaxX: ->
    node = @root
    node = node.right while node.right isnt null
    return node.x

  getMaxY: ->
    helper = (node, maxY) ->
      maxY = Math.max maxY, node.y
      maxY = Math.max maxY, helper node.left, maxY if node.left isnt null
      maxY = Math.max maxY, helper node.right, maxY if node.right isnt null
      maxY
    helper @root, 0

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
    input = input.replace /\s/g, '' # Remove all whitespace
    root = @parse input
    if root is null
      @root = null
    else
      @root = new VisualNode root
      @root.init 0
    @draw()

update = (trees) ->
    inputField = document.getElementById 'inputfield'
    trees.update inputField.value

window.onload = ->
  trees = new Trees

  # Updating and saving
  document.getElementById('updatebutton').onclick = -> update trees
  document.getElementById('savebutton').onclick = -> trees.save()

  # Colors
  textColorPicker = document.getElementById 'textcolor'
  nodeColorPicker = document.getElementById 'nodecolor'
  lineColorPicker = document.getElementById 'linecolor'
  bgColorPicker   = document.getElementById 'bgcolor'
  textColorPicker.onchange = ->
    VisualNode.textColor = '#' + this.color
    update trees
  nodeColorPicker.onchange = ->
    VisualNode.nodeColor = '#' + this.color
    update trees
  lineColorPicker.onchange = ->
    VisualNode.lineColor = '#' + this.color
    Trees.lineColor = '#' + this.color
    update trees
  bgColorPicker.onchange = ->
    Trees.bgColor = '#' + this.color
    update trees
  textColorPicker.color.fromString '66180c'
  nodeColorPicker.color.fromString '4dff7c'
  lineColorPicker.color.fromString '31571b'
  bgColorPicker.color.fromString   '52b4ff'
  textColorPicker.onchange()
  nodeColorPicker.onchange()
  lineColorPicker.onchange()
  bgColorPicker.onchange()
