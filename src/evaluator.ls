
# Require

{ log } = require \./helpers
{ id, keys, values }  = require \prelude-ls

require! \LiveScript
require! \coffee-script


# Evaluator class

export class Evaluator

  std-args = [ \log ]
  sec-args = [ \window \top \document ]

  (lang = \ls) ->

    log "new Evaluator (#lang)"

    @scope   = {}
    @globals =
      log: log

    # These are very large modules so only require what you need
    @compile = switch lang
    | \ls => -> LiveScript.compile it, bare: true
    | \cs => -> coffee-script.compile it, bare: true
    | \js => id


  eval: (source) ->
    body = @compile source
    args = (keys @globals) ++ sec-args ++ body
    vals = (values @globals)

    (Function.apply null, args).apply @scope, vals


