'use strict'

class SlideActionCtrl
  constructor: (Slides, $scope) ->
    this.Slides = Slides
    this.$scope = $scope

  $onInit: () ->
    ctrl = this

angular.module 'homemademessClient'
.component 'slideAction',
  bindings:
    slide: '<'
  controller: ['Slides', '$scope', SlideActionCtrl]
