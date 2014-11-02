
# Helpers

{ log, delay } = require \./helpers


# Require

{ id } = require \prelude-ls

{ Editor }    = require \./editor
{ World2D }   = require \./world-2d
{ Evaluator } = require \./evaluator


# Instantiate modules

world = new World2D
world.install document.body

evaluator = new Evaluator \ls
evaluator.globals <<< { log, canvas: world.canvas, ctx: world.ctx }

editor = new Editor
editor.install document.body
editor.on-execute evaluator~eval


# Prepare starting state

editor.load """
  @frame = (time) ->
    x1 = 200 *  Math.sin time/300
    y1 = 200 *  Math.cos time/300
    x2 = 200 * -Math.sin time/300
    y2 = 200 * -Math.cos time/300
    ctx.move-to canvas.width/2 + y1, canvas.height/2 + y1
    ctx.line-to canvas.width/2 + x2, canvas.height/2 + x2
    ctx.move-to canvas.width/2 + x2, canvas.height/2 + x1
    ctx.line-to canvas.width/2 + y2, canvas.height/2 + y1
    ctx.move-to canvas.width/2 + x1, canvas.height/2 + y1
    ctx.line-to canvas.width/2 + y2, canvas.height/2 + x2
    ctx.move-to canvas.width/2 + x1, canvas.height/2 + x2
    ctx.line-to canvas.width/2 + y1, canvas.height/2 + y2
    ctx.stroke!
"""


# Begin automatically

delay 300, ->
  editor.execute-chunk!
  world.start -> evaluator.scope.frame ...


