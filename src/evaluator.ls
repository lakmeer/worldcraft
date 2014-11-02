
# Require

{ log } = require \./helpers
{ id, keys, values }  = require \prelude-ls

require! \LiveScript
require! \coffee-script


# Evaluator class

export class Evaluator

  std-args = [ \log ]
  sec-args = [ \window \top \document ]

  (lang = \javascript) ->

    log "new Evaluator (#lang)"

    @scope   = {}
    @globals =
      log: log

    # These are very large modules so only require what you need
    @compile = switch lang
    | \livescript   => -> LiveScript.compile it, bare: true
    | \coffeescript => -> coffee-script.compile it, bare: true
    | \javascript   => id


  eval: (source) ->
    body = @compile source
    args = (keys @globals) ++ sec-args ++ body
    vals = (values @globals)

    (Function.apply null, args).apply @scope, vals


