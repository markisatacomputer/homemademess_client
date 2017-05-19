'use strict'

class SlidesActionCtrl
  constructor: ($scope, Slides) ->
    this.$scope = $scope
    this.Slides = Slides

  $onInit: () ->
    ctrl = this

    #  draw selected images
    this.$scope.$on 'slide.remove', (e, img) ->
      ctrl.Slides.delete {id: img._id}, (r) ->

angular.module 'homemademessClient'
.component 'slidesActionControl',
  controller: SlidesActionCtrl