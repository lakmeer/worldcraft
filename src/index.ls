
# Helpers

{ log } = require \./helpers.ls


# Require

VRDevice = require \./vr-device.ls

[ hmd, sensor ] <- VRDevice.init!

log hmd, sensor

