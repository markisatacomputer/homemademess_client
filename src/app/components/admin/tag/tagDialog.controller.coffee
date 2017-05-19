'use strict'

class TagDialogCtrl
  constructor: (Auto, Tags, socketService, tagDialogService, $mdDialog) ->
    ctrl = this
    socketService.then (s) ->
      ctrl.socketService = s

    this.Auto = Auto
    this.Tags = Tags
    this.tagDialogService = tagDialogService
    this.$mdDialog = $mdDialog
    this.selectedTags = []
    this.searchText
    this.selectedItem

    this.tagDialogService.get().then (tags) ->
      ctrl.tagsInView = tags

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
  addTagToTagsInView: (tag) ->
    add = true
    angular.forEach this.tagsInView.ids, (t, i) ->
      if t == tag._id
        add = false

    if add
      this.tagsInView.objects.push tag
      this.tagsInView.ids.push tag._id

  remove: (tagId) ->
    this.socketService.emit 'selected:tags:remove', {tagIds: [tagId]}

  add: ->
    ctrl = this

    #  save new tags
    stop = false
    angular.forEach this.selectedTags, (tag, i) ->
      if !tag._id?
        stop = true
        ctrl.Tags.save tag, (t) ->
          ctrl.selectedTags[i] = t
          ctrl.add()

    #  stop if we just sent a new tag to be created
    if stop then return false

    #  add tags to selected images
    if this.selectedTags.length > 0
      #  extract tag ids
      tagids = this.getSelectedTagIds()
      #  send to api
      this.tagDialogService.add tagids
      .then (r) ->
        #  update tag list
        angular.forEach ctrl.selectedTags, (tag, i) ->
          ctrl.addTagToTagsInView tag
        #  clear search
        ctrl.clearSelectedTags()

angular.module 'homemademessClient'
.controller 'TagDialogCtrl', TagDialogCtrl