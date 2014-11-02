
# Helpers

{ log, delay } = require \./helpers


# Require

{ id } = require \prelude-ls

{ Editor } = require \./editor
{ Evaluator } = require \./evaluator


# Prepare

time    = Date.now!
Δt      = 0
stopped = no

canvas = document.create-element \canvas
canvas.class-name = \canvas
canvas.width = window.inner-width
canvas.height = window.inner-height

ctx = canvas.get-context \2d
document.body.append-child canvas

evaluator = new Evaluator \ls
evaluator.globals <<< { log, canvas, ctx }

editor = new Editor
editor.install document.body
editor.on-execute evaluator~eval

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


# Per-frame

frame = ->
  request-animation-frame frame unless stopped
  Δt   := Date.now! - time
  time := Date.now!
  ctx.clear-rect 0, 0, canvas.width, canvas.height
  canvas.width = canvas.width
  evaluator.scope.frame? time, Δt


# Prod self into life

delay 300, ->
  editor.execute-chunk!
  frame!


# Register the escape key as a quick hack to shut it down

document.add-event-listener \keydown, ({ which, shift-key }) ->
  if shift-key and which is 27
    log "Halting frame loop"
    stopped := true

