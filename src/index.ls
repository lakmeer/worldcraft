
# Helpers

{ log, delay } = require \./helpers


# Require

{ id } = require \prelude-ls

{ EditorCM }    = require \./editor
{ World2D }   = require \./world-2d
{ Evaluator } = require \./evaluator


# Instantiate modules

world     = new World2D
evaluator = new Evaluator \livescript
editor    = new EditorCM mode: \livescript


# Example programs

double-helix2d = """
  @frame = (time) ->
    count = 50
    size = canvas.height/count
    width = canvas.width/3
    speed = 0.002

    for i in [0 to count]
      amp = Math.sin(time*speed + i * Math.PI / 24)
      pos = canvas.width/2 + width/2 * amp
      col = Math.sin(time*speed + i * Math.PI / 24 + Math.PI/2)
      ctx.fill-style = "rgb(\#{128 + Math.floor(col/2 * 255)}, 0, 0)"
      ctx.fill-rect pos, size * i, size, size * 4

      amp = -Math.sin(time*speed + i * Math.PI / 24)
      col = -Math.sin(time*speed + i * Math.PI / 24 + Math.PI/2)
      pos = canvas.width/2 + width/2 * amp
      ctx.fill-style = "rgb(0, 0, \#{128 + Math.floor(col/2 * 255)})"
      ctx.fill-rect pos, size * i, size, size * 4
"""


# Assemble modules and set intial state

evaluator.globals <<< { log, canvas: world.canvas, ctx: world.ctx }
editor.install document.body
editor.load double-helix2d
editor.on-execute evaluator~eval
world.install document.body

delay 300, ->
  editor.execute-all!
  world.start -> evaluator.scope.frame ...

