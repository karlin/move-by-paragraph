_ = require 'underscore-plus'
{$$, Point, Range} = require 'atom'
#
# Shamelessly lifted from atom/vim-mode:
#
class MoveToNextParagraph
  constructor: (@editor) ->
  execute: (count=1) ->
    _.times count, =>
      @editor.setCursorScreenPosition(@nextPosition())

  select: (count=1) ->
    _.times count, =>
      @editor.selectToScreenPosition(@nextPosition())
      true

  # Private: Finds the beginning of the next paragraph
  #
  # If no paragraph is found, the end of the buffer is returned.
  nextPosition: ->
    start = @editor.getCursorBufferPosition()
    scanRange = [start, @editor.getEofBufferPosition()]

    {row, column} = @editor.getEofBufferPosition()
    position = new Point(row, column - 1)

    @editor.scanInBufferRange /^\n*$/g, scanRange, ({range, stop}) =>
      if !range.start.isEqual(start)
        position = range.start
        stop()

    @editor.screenPositionForBufferPosition(position)

class MoveToPreviousParagraph
  constructor: (@editor) ->
  execute: (count=1) ->
    _.times count, =>
      @editor.setCursorScreenPosition(@previousPosition())

  select: (count=1) ->
    _.times count, =>
      @editor.selectToScreenPosition(@previousPosition())
      true

  # Private: Finds the beginning of the previous paragraph
  #
  # If no paragraph is found, the beginning of the buffer is returned.
  previousPosition: ->
    start = @editor.getCursorBufferPosition()
    {row, column} = start
    scanRange = [[row-1, column], [0,0]]
    position = new Point(0, 0)
    @editor.backwardsScanInBufferRange /^\n*$/g, scanRange, ({range, stop}) =>
      if !range.start.isEqual(new Point(0,0))
        position = range.start
        stop()
    @editor.screenPositionForBufferPosition(position)

module.exports =
  activate: (state) ->
    atom.workspace.eachEditor (editor) ->
      atom.workspaceView.command "move-by-paragraph:move-to-next-paragraph", => (new MoveToNextParagraph(editor)).execute()
      atom.workspaceView.command "move-by-paragraph:select-to-next-paragraph", => (new MoveToNextParagraph(editor)).select()
      atom.workspaceView.command "move-by-paragraph:move-to-previous-paragraph", => (new MoveToPreviousParagraph(editor)).execute()
      atom.workspaceView.command "move-by-paragraph:select-to-previous-paragraph", => (new MoveToPreviousParagraph(editor)).select()
