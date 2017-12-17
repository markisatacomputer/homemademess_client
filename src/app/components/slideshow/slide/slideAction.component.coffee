'use strict'

class SlideActionCtrl
  constructor: (Slides, $scope, $mdDialog, broadcastService) ->
    this.Slides = Slides
    this.$scope = $scope
    this.$mdDialog = $mdDialog
    this.broadcastService = broadcastService

  $onInit: () ->
    ctrl = this

    #  TAG
    this.$scope.$on 'slide.tag', (e) ->
      ctrl.$mdDialog.show
        clickOutsideToClose: true
        templateUrl: 'app/components/admin/tag/tagDialog.html'
        controller: 'TagDialogCtrl'
        controllerAs: 'ctrl'
        multiple: true

    #  DELETE
    this.$scope.$on 'slide.delete', (e) ->
      # confirm delete
      confirm = ctrl.$mdDialog.confirm()
      .title 'Do you really want to delete this image?'
      .ok 'Yes please'
      .cancel 'oops - no dont!'
      .multiple true

      ctrl.$mdDialog.show(confirm).then () ->
        ctrl.Slides.delete {id: img._id}, (r) ->
          ctrl.broadcastService.send 'slideshow.exit'
      , () ->
        true

angular.module 'homemademessClient'
.component 'slideAction',
  bindings:
    slide: '<'
  controller: ['Slides', '$scope', '$mdDialog', 'broadcastService', SlideActionCtrl]
