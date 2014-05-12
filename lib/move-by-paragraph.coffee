_ = require 'underscore-plus'
{$$, Point, Range} = require 'atom'

module.exports =
  activate: (state) ->
    atom.workspaceView.command "move-by-paragraph:move-to-next-paragraph", => @byParagraph('move', 'next')
    atom.workspaceView.command "move-by-paragraph:select-to-next-paragraph", => @byParagraph('select', 'next')
    atom.workspaceView.command "move-by-paragraph:move-to-previous-paragraph", => @byParagraph('move', 'previous')
    atom.workspaceView.command "move-by-paragraph:select-to-previous-paragraph", => @byParagraph('select', 'previous')

  #
  # Shamelessly lifted from atom/vim-mode:
  #
  nextParaPosition: (editor) ->
    start = editor.getCursorBufferPosition()
    scanRange = [start, editor.getEofBufferPosition()]

    {row, column} = editor.getEofBufferPosition()
    position = new Point(row, column - 1)

    editor.scanInBufferRange /^\n*$/g, scanRange, ({range, stop}) =>
      if !range.start.isEqual(start)
        position = range.start
        stop()
    editor.screenPositionForBufferPosition(position)

  prevParaPosition: (editor) ->
    start = editor.getCursorBufferPosition()

    {row, column} = start
    scanRange = [[row-1, column], [0,0]]
    position = new Point(0, 0)
    zero = new Point(0,0)
    editor.backwardsScanInBufferRange /^\n*$/g, scanRange, ({range, stop}) =>
      if !range.start.isEqual(zero)
        position = range.start
        stop()
    editor.screenPositionForBufferPosition(position)

  byParagraph: (action, dir) ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    dirs =
      next: @nextParaPosition
      previous: @prevParaPosition

    if action is 'select'
      editor.selectToScreenPosition dirs[dir](editor)
    else
      editor.setCursorScreenPosition dirs[dir](editor)
