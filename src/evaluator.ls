
# Require

{ log } = require \./helpers
{ id, keys, values }  = require \prelude-ls

LS = require \LiveScript
CS = require \coffee-script


# Evaluator class

export class Evaluator

  sec-args = [ \window \top \document ]

  (lang = \javascript) ->

    log "new Evaluator (#lang)"

    @scope   = {}
    @globals = {}

    # These are very large modules so only require what you need
    @compile = switch lang
    | \livescript   => -> LS.compile it, bare: true
    | \coffeescript => -> CS.compile it, bare: true
    | \javascript   => id

  eval: (source) ->
    body = @compile source
    args = (keys @globals) ++ sec-args ++ body
    vals = (values @globals)
    (Function.apply null, args).apply @scope, vals

