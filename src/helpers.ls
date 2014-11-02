
# Require

prelude = require \prelude-ls


# Export helper functions

export log = -> console.log.apply console, &; &0

export delay = prelude.flip set-timeout

export swallow = (.prevent-default?!)


# Keycode enum

export Key =
  ENTER: 13

