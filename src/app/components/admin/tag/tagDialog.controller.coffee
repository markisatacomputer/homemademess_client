'use strict'

class TagDialogCtrl
  constructor: (Auto, Tags, Slides, tagDialogService, $mdDialog, image) ->
    ctrl = this

    this.Auto = Auto
    this.Tags = Tags
    this.Slides = Slides
    this.tagDialogService = tagDialogService
    this.$mdDialog = $mdDialog
    this.image = image
    this.selectedTags = []
    this.searchText
    this.selectedItem

    #  if image exists we are editing one image rather than selected
    if this.image?
      ctrl.tagsInView = this.image.tags
    else
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
    #  single image
    if this.image?
      this.Slides.update { id: this.image._id }, { tags: this.image.tags.map (t) -> t._id }
    #  selected images
    else
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
      #  single image
      if this.image?
        newtags = ctrl.image.tags.concat(ctrl.selectedTags).map (t) ->t._id
        #  save and update
        ctrl.Slides.update { id: this.image._id }, { tags: newtags }, (img) ->
          ctrl.tagsInView = img.tags
          ctrl.clearSelectedTags()
      #  selected images
      else
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
.controller 'TagDialogCtrl', ['Auto', 'Tags', 'Slides', 'tagDialogService', '$mdDialog', 'image', TagDialogCtrl]