# MoveByParagraph = require '../lib/move-by-paragraph'
{WorkspaceView} = require 'atom'

path = require 'path'
# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "MoveByParagraph", ->
  [editor, editorView] = []

  beforeEach ->
    runs ->
      atom.workspaceView = new WorkspaceView
      atom.workspaceView.openSync('sample.txt')

    runs ->
      atom.workspaceView.attachToDom()
      editorView = atom.workspaceView.getActiveView()

    waitsForPromise ->
      promise = atom.packages.activatePackage('move-by-paragraph')
      atom.workspaceView.trigger 'move-by-paragraph:move-to-previous-paragraph'
      promise

    runs ->
      {editor} = editorView

  describe "when the move-by-paragraph events are triggered", ->
    it "moves to the next paragraph", ->
      editor.moveCursorToBeginningOfLine()
      editorView.trigger 'move-by-paragraph:move-to-next-paragraph'
      expect(editor.getCursorBufferPosition()).toEqual [1, 0]
      editorView.trigger 'move-by-paragraph:move-to-next-paragraph'
      expect(editor.getCursorBufferPosition()).toEqual [4, 0]

    it "moves to the previous paragraph", ->
      editor.moveCursorToBeginningOfLine()
      editorView.trigger 'move-by-paragraph:move-to-previous-paragraph'
      expect(editor.getCursorBufferPosition()).toEqual [0, 0]
      editorView.trigger 'move-by-paragraph:move-to-next-paragraph'
      editorView.trigger 'move-by-paragraph:move-to-next-paragraph'
      expect(editor.getCursorBufferPosition()).toEqual [4, 0]
      editorView.trigger 'move-by-paragraph:move-to-previous-paragraph'
      expect(editor.getCursorBufferPosition()).toEqual [1, 0]

    it "selects to the previous paragraph", ->
      expect('to do')
    it "selects to the next paragraph", ->
      expect('to do')
