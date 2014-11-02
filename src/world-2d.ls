
export class World2D

  ->

    # Dom
    @canvas = document.create-element \canvas
    @ctx    = @canvas.get-context \2d

    # State
    @time = Date.now!
    @Δt   = 0
    @running = no

  init: ->
    @canvas.class-name = \canvas
    @canvas.width  = window.inner-width
    @canvas.height = window.inner-height

    # Register the shift+escape as a quick hack to shut it down
    document.add-event-listener \keydown, ({ which, shift-key }) ->
      if shift-key and which is 27
        log "Halting frame loop"
        @running := no

  clear: ->
    @canvas.width = @canvas.width

  install: (host) ->
    host.append-child @canvas

  start: (λ) ->
    @init!
    @running = yes
    @frame λ

  frame: (λ) ->
    if @running then request-animation-frame ~> @frame λ
    now   = Date.now!
    @Δt   = now - @time
    @time = now
    @clear!
    λ? @time, @Δt

