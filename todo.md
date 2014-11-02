
# TODO

## Program outline

- Instantiate an editor
- Place editor in world
- Boot Three and load base scene
- Expose useful helpers to the editor
- Detect VR headset
- Begin frame loop


## Development Outline

- Editor module
  - Allow per-chunk evaluation (like Slime)
  - Use Browserify or similar to join multiple editor windows
  - Syntax highlighting
  - Ace or Codemirror, probably

- VR Module
  - Detect and initialise HMD
  - Read HMD orientation, translate to CSS matrix
  - Provide transofrm matrixes to World module

- Compilation module
  - Receive code snippets from editor
  - Compile various languages
  - Allow live-compilation of livescript (and coffeescript, I guess)

- World Module
  - Control exposure of scene data to editor
  - Provide shared variables to Compilation module
  - Execute compiled code from Compilation module
  - Track time consistently and provide frame-corrected value to editor
  - Run the frame loop

- Audio module
  - Play a song
  - Load a song
  - Expose node values to editor

