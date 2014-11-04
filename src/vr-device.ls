
# Helpers

log = -> if LOGGING then console.apply console, &; &0
id  = -> it


# Require

{ Quaternion } = require \./quaternion.ls


# Shared scope variables for later

LOGGING       = no

vr-hmd        = null
vr-sensor     = null
css-camera    = null
css-container = null


# Bind keys for managing display modes

onkey = ({ char-code }) ->
  switch String.fromCharCode char-code
  | \f => css-container.mozRequestFullScreen vr-display: vr-hmd
  | \z => vrSensor.zero-sensor!


# Request VR devices from UA

export init = (λ-success, λ-error = id) ->
  log 'VR::Init - Searching for HMD'
  css-camera    := document.getElementById \camera
  css-container := document.getElementById \container

  unless navigator.getVRDevices?
    λ-error code: 3, message: "WebVR not supported in this browser"

  log "VR::Init - Requesting VR Devices from useragent..."

  navigator.getVRDevices!then (devices) ->
    log "VR::Init - Browsing VR Devices (#{devices.length} devices)"

    # Pick out HMD's
    for device in devices when device instanceof HMDVRDevice
      log "VR::Init - Found HMD '#{device.device-name}'"
      hmd = device
      break

    # Did we find any HMD's?
    if not hmd?
      error "VR:Init - Failed to find any HMD"
      λ-error code: 1, message: "No HMD detected."

    # Then, find that HMD's position sensor
    for device in devices when device instanceof PositionSensorVRDevice
      if device.hardware-unit-id is hmd.hardware-unit-id
        log "VR::init - Found VR Position Sensor '#{device.device-name}' matching '#{hmd.device-name}'"
        sensor = device
        break
      else
        log "VR::init - Found VR Position Sensor '#{device.device-name}' but no HMD match."

    # Did we find a matching sensor?
    if not sensor?
      log "VR::init - Found an HMD, but didn't find it's orientation sensor."
      λ-error code: 2, message: "No matching sensor found"

    # Return findings
    λ-success [ hmd, sensor ]


# Per-frame callback

export get-camera-transform = (vr-sensor) ->
  o = Quaternion.from-orientation vr-sensor.get-state!orientation

export to-css-matrix = (orientation) ->
  #requestAnimationFrame frame
  m = orientation.to-matrix!
  transform = "matrix3d(#m) translate3d(0,0,0) rotateZ(180deg) rotateY(180deg)"


