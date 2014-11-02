
# Require

{ log, swallow, delay, Key } = require \./helpers
{ keys, lines, split } = require \prelude-ls


# Reference constants

flash-time = 100


# Editor Class
#
# TODO: Check if chunk split technique works in non-V8 browsers

export class Editor

  ->
    log 'new Editor'

    @dom = document.create-element \textarea
    @dom.class-name = \editor

    @callbacks = execute: []

    @dom.add-event-listener \keypress, ({ which, ctrl-key, shift-key }) ~>
      switch which
      | Key.ENTER =>
        if ctrl-key
          swallow event
          if shift-key
            @execute-all!
          else
            @execute-chunk!

  get-cursor-position: ->
    @dom.selection-start

  get-chunk-extents: (text, pos, chars-traversed = 0) ->
    for chunk in text.split \\n\n
      if chars-traversed + chunk.length + 1 >= pos
        return [ chars-traversed, chars-traversed + chunk.length ]
      else
        chars-traversed += chunk.length + 2
    return text

  execute: (code) ->
    [ λ code for λ in @callbacks.execute ]

  execute-all: ->
    @execute @dom.value
    @flash-all!

  execute-chunk: ->
    cursor-pos = @dom.selection-start
    extents = @get-chunk-extents @dom.value, cursor-pos
    @execute @get-text-inside extents
    @flash-chunk extents, cursor-pos

  get-text-inside: ([ start, end ]) ->
    @dom.value.substring start, end

  on-execute: (λ) ->
    @callbacks.execute.push λ

  install: (host) ->
    host.append-child @dom
    @dom.focus!

  load: (text) ->
    @dom.value = text

  flash-chunk: ([ start, end ], pos) ->
    @dom.selection-start = start
    @dom.selection-end = end
    delay flash-time, ~>
      @dom.selection-start = pos
      @dom.selection-end = pos

  flash-all: ->
    @dom.class-name = "editor flashing"
    delay flash-time, ~> @dom.class-name = "editor"

