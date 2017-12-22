'use strict'

class TagDialogCtrl
  constructor: (Auto, Tags, tagDialogService, $mdDialog) ->
    ctrl = this

    this.Auto = Auto
    this.Tags = Tags
    this.tagDialogService = tagDialogService
    this.$mdDialog = $mdDialog
    this.selectedTags = []
    this.searchText
    this.selectedItem

    this.tagDialogService.get().then (tags) ->
      ctrl.tagsInView = tags.objects

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

  remove: (tag) ->
    this.tagDialogService.remove tag._id

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
        ctrl.tagDialogService.get().then (tags) ->
          ctrl.tagsInView = tags.objects
          ctrl.clearSelectedTags()


angular.module 'homemademessClient'
.controller 'TagDialogCtrl', ['Auto', 'Tags', 'tagDialogService', '$mdDialog', TagDialogCtrl]