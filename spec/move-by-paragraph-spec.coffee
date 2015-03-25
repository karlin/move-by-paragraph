path = require 'path'
# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "MoveByParagraph", ->
  [editor, editorElement, workspaceElement] = []

  beforeEach ->
    runs ->
      workspaceElement = atom.views.getView(atom.workspace)

    waitsForPromise ->
      atom.workspace.open('sample.txt').then (ed) ->
        editor = ed
        editorElement = atom.views.getView(ed)

    waitsForPromise ->
      promise = atom.packages.activatePackage('move-by-paragraph')
      atom.commands.dispatch workspaceElement, 'move-by-paragraph:move-to-previous-paragraph'
      promise

  describe "when the move-by-paragraph events are triggered", ->
    it "moves to the next paragraph", ->
      editor.moveToBeginningOfLine()
      atom.commands.dispatch editorElement, 'move-by-paragraph:move-to-next-paragraph'
      expect(editor.getCursorBufferPosition()).toEqual [1, 0]
      atom.commands.dispatch editorElement, 'move-by-paragraph:move-to-next-paragraph'
      expect(editor.getCursorBufferPosition()).toEqual [4, 0]

    it "moves to the previous paragraph", ->
      editor.moveToBeginningOfLine()
      atom.commands.dispatch editorElement, 'move-by-paragraph:move-to-previous-paragraph'
      expect(editor.getCursorBufferPosition()).toEqual [0, 0]
      atom.commands.dispatch editorElement, 'move-by-paragraph:move-to-next-paragraph'
      atom.commands.dispatch editorElement, 'move-by-paragraph:move-to-next-paragraph'
      expect(editor.getCursorBufferPosition()).toEqual [4, 0]
      atom.commands.dispatch editorElement, 'move-by-paragraph:move-to-previous-paragraph'
      expect(editor.getCursorBufferPosition()).toEqual [1, 0]

    it "selects to the previous paragraph", ->
      editor.moveToBeginningOfLine()
      atom.commands.dispatch editorElement, 'move-by-paragraph:select-to-next-paragraph'
      expect(editor.getSelectedBufferRange()).toEqual [[0, 0], [1, 0]]
      atom.commands.dispatch editorElement,
      'move-by-paragraph:select-to-next-paragraph'
      expect(editor.getSelectedBufferRange()).toEqual [[0, 0], [4, 0]]

    it "selects to the next paragraph", ->
      editor.moveToBeginningOfLine()
      atom.commands.dispatch editorElement, 'move-by-paragraph:select-to-previous-paragraph'
      expect(editor.getSelectedBufferRange()).toEqual [[0, 0], [0, 0]]
      atom.commands.dispatch editorElement, 'move-by-paragraph:move-to-next-paragraph'
      atom.commands.dispatch editorElement, 'move-by-paragraph:move-to-next-paragraph'
      expect(editor.getCursorBufferPosition()).toEqual [4, 0]
      atom.commands.dispatch editorElement, 'move-by-paragraph:select-to-previous-paragraph'
      expect(editor.getSelectedBufferRange()).toEqual [[4, 0], [1, 0]]
      atom.commands.dispatch editorElement, 'move-by-paragraph:select-to-previous-paragraph'
      expect(editor.getSelectedBufferRange()).toEqual [[4, 0], [0, 0]]
