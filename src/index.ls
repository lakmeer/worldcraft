
# Helpers

{ log, delay } = require \./helpers


# Require

{ id } = require \prelude-ls

{ EditorCM }  = require \./editor
{ World2D }   = require \./world-2d
{ World3D }   = require \./world-3d
{ Evaluator } = require \./evaluator


# Instantiate modules

world     = new World3D
evaluator = new Evaluator \livescript
editor    = new EditorCM mode: \livescript


# Example programs

double-helix2d = """
  count = 50
  size = canvas.height/count
  width = canvas.width/3
  speed = 0.002

  @frame = (time) ->
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

double-helix3d = """
  geom = new THREE.BoxGeometry 1, 1, 1
  ogeom = new THREE.BoxGeometry 0.1, 0.1, 0.1
  red  = new THREE.MeshPhongMaterial color: 0xdd0000
  blue = new THREE.MeshPhongMaterial color: 0x0000dd

  light = new THREE.PointLight 0xffffff, 1, 100
  light.position.set 0, 0, 0
  scene.add light

  camera.position.z = 35

  count = 50
  @s = 0.002
  @r = 5

  @cubes = for i in [0 to count]
    scene.add red-cube   = new THREE.Mesh geom, red
    scene.add blue-cube  = new THREE.Mesh geom, blue
    red-cube.position.y  = -count/2 + i
    blue-cube.position.y = -count/2 + i
    [ red-cube, blue-cube ]

  @frame = (time) ->
    for [ red, blue ], i in @cubes
      red.position.z = -Math.sin(time*@s + i * Math.PI / 24) * @r
      red.position.x = -Math.cos(time*@s + i * Math.PI / 24) * @r
      blue.position.z = Math.sin(time*@s + i * Math.PI / 24) * @r
      blue.position.x = Math.cos(time*@s + i * Math.PI / 24) * @r
"""


# Assemble modules and set intial state

viewport  = document.get-element-by-id \viewport
camera    = document.get-element-by-id \camera

evaluator.globals <<< { log, canvas: world.canvas, ctx: world.ctx }
evaluator.globals <<< { THREE, scene: world.scene, camera: world.camera }
editor.install camera
editor.load double-helix3d
editor.on-execute evaluator~eval
world.install viewport


# VR Testing

VR = require \./vr-device

VR.init ([ hmd, sensor ]) ->
  editor.execute-all!
  world.start ->
    evaluator.scope.frame.apply evaluator.scope, &
    camera-orientation       = VR.get-camera-transform sensor
    camera.style.transform   = VR.to-css-matrix camera-orientation
    world.camera._quaternion = camera-orientation

  document.add-event-listener \keydown, ({ which, key-code }) ~>
    switch which
    | 70 => viewport.moz-request-full-screen vr-display: hmd
    | 90 => sensor.zero-sensor!


