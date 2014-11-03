
# Require

{ log } = require \./helpers


# World class (2d until I get THREE up and running)

export class World3D

  ->
    # World
    @scene    = new THREE.Scene!
    @camera   = new THREE.PerspectiveCamera 75, window.innerWidth/window.innerHeight, 0.1, 1000
    @renderer = new THREE.WebGLRenderer!

    # State
    @time = Date.now!
    @Δt   = 0
    @running = no

  init: ->
    @renderer.set-size window.innerWidth, window.innerHeight
    @renderer.set-clear-color 0xffffff
    @renderer.dom-element.class-name = \canvas

    # Register the shift+escape as a quick hack to shut it down
    document.add-event-listener \keydown, ({ which, shift-key }) ~>
      if which is 27
        console.warn "Halting frame loop"
        @running := no

  install: (host) ->
    host.append-child @renderer.dom-element

  start: (λ) ->
    @init!
    @running = yes
    @frame λ

  frame: (λ, ctx) ->
    if @running then request-animation-frame ~> @frame λ, ctx
    now   = Date.now!
    @Δt   = now - @time
    @time = now
    λ?.call ctx, @time, @Δt
    @renderer.render @scene, @camera

