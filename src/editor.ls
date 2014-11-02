
# Require

{ log, swallow, delay, Key } = require \./helpers
{ keys, lines, split } = require \prelude-ls

CodeMirror = require \codemirror

mode-js = require \codemirror/mode/javascript/javascript.js
mode-cs = require \codemirror/mode/coffeescript/coffeescript.js
mode-ls = require \codemirror/mode/livescript/livescript.js


# Reference constants

flash-time = 100


# Helpers

chunk-extents-at-pos = (text, ix, chars-traversed = 0) ->
  for chunk in text.split \\n\n
    if chars-traversed + chunk.length + 1 >= ix
      return [ chars-traversed, chars-traversed + chunk.length ]
    else
      chars-traversed += chunk.length + 2
  return [ 0, text.length ]


# Editor Class
#
# TODO: Check if chunk split technique works in non-V8 browsers

export class Editor

  ->

    log "new Editor"

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


  # Implementation agnostic

  install: (host) ->
    host.append-child @dom
    @dom.focus!

  execute: (code) ->
    try [ λ code for λ in @callbacks.execute ]

  execute-all: ->
    @execute @get-contents!
    @flash-all!

  execute-chunk: ->
    cursor-pos = @get-cursor-position!
    extents = @get-chunk-extents @get-contents!, cursor-pos
    @execute @get-text-inside extents
    @flash-chunk extents, cursor-pos

  on-execute: (λ) ->
    @callbacks.execute.push λ

  # Implementation-specific

  get-cursor-position: ->
    @dom.selection-start

  get-chunk-extents: (text, pos) ->
    chunk-extents-at-pos text, pos

  get-contents: ->
    @dom.value

  get-text-inside: ([ start, end ]) ->
    @dom.value.substring start, end

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



export class EditorCM extends Editor

  ({ mode = \javascript, a = \b }:config = {}) ->

    log "new Editor (#mode)"

    @dom = document.create-element \div
    @dom.class-name = \editor

    @cm = CodeMirror @dom, do
      mode: mode
      theme: \neo

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


  # Implementation-specific

  load: ->
    @cm.set-value it
    @cm.exec-command \goDocEnd

  get-cursor-position: -> @cm.get-cursor!

  get-chunk-extents: (text, pos) ->
    [ start, end ] = chunk-extents-at-pos text, @cm.index-from-pos pos
    [ (@cm.pos-from-index start), (@cm.pos-from-index end) ]

  get-contents: ->
    @cm.get-value!

  get-text-inside: ([ start, end ]) ->
    @cm.get-range start, end

  flash-chunk: ([ start, end ], pos) ->
    marker = @cm.mark-text start, end, class-name: \flashing
    delay flash-time, marker~clear

  flash-all: ->
    @dom.class-name = "editor flashing"
    delay flash-time, ~> @dom.class-name = "editor"

