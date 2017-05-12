'use strict'

class TagDialogCtrl
  constructor: (Auto, Tags, socketService) ->
    ctrl = this
    socketService.then (s) ->
      ctrl.socketService = s

    this.Auto = Auto
    this.Tags = Tags
    this.selectedTags = []
    this.searchText
    this.selectedItem

  findTags: (value) ->
    this.Auto.query {q:value}

  prepareTag: (tag) ->
    if angular.isObject tag and tag.hasOwnProperty 'text' then tag
    else if angular.isString tag then {text: tag, _images: []}

  clearSelectedTags: ->
    this.selectedTags = []
  getSelectedTagIds: ->
    return this.selectedTags.map (tag) ->
      tag._id

  remove: (tagId) ->
    this.socketService.emit 'selected:tags:remove', {tagIds: [tagId]}
  add: ->
    ctrl = this
    #  save new tags
    angular.forEach this.selectedTags, (tag, i) ->
      if !tag._id?
        ctrl.Tags.save tag, (t) ->
          ctrl.selectedTags[i] = t
          ctrl.add ctrl.selectedTags
    #  add tags to selected images
    if this.selectedTags.length > 0
      this.socketService.emit 'selected:tags:add', {tagIds: this.getSelectedTagIds()}
      this.clearSelectedTags()


angular.module 'homemademessClient'
.controller 'TagDialogCtrl', TagDialogCtrl