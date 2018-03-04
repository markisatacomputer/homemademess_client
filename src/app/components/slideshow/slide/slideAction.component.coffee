'use strict'

class SlideActionCtrl
  constructor: (Slides, $scope, $mdDialog, broadcastService, Download) ->
    this.Slides = Slides
    this.$scope = $scope
    this.$mdDialog = $mdDialog
    this.broadcastService = broadcastService
    this.Download = Download

  removeTag: (tag) ->
    this.Slides.update { id: this.image._id }, { tags: this.image.tags.map (t) -> t._id }

  $onInit: () ->
    ctrl = this

    #  DOWNLOAD
    this.$scope.$on 'slide.download', (e) ->
      download = ctrl.slide._id+'/'+ctrl.slide.filename
      ctrl.Download.one {id: download}, (data) ->
        a = document.createElement 'a'
        a.href = data.response
        a.download = ctrl.slide.filename
        a.click()

    #  DELETE
    this.$scope.$on 'slide.delete', (e) ->
      # confirm delete
      confirm = ctrl.$mdDialog.confirm()
      .title 'Do you really want to delete this image?'
      .ok 'Yes please'
      .cancel 'Oops - no dont!'
      .multiple true

      ctrl.$mdDialog.show(confirm).then () ->
        ctrl.Slides.delete {id: ctrl.slide._id}, (r) ->
          ctrl.broadcastService.send 'slideshow.exit'
      , () ->
        true

angular.module 'homemademessClient'
.component 'slideAction',
  bindings:
    slide: '<'
  controller: ['Slides', '$scope', '$mdDialog', 'broadcastService', 'Download', SlideActionCtrl]
