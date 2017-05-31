'use strict'

class DeleteCtrl
  constructor: ($scope, Slides) ->
    this.$scope = $scope
    this.Slides = Slides

  $onInit: () ->
    ctrl = this

    #  DELETE
    this.$scope.$on 'slide.remove', (e, img) ->
      ctrl.Slides.delete {id: img._id}, (r) ->

angular.module 'homemademessClient'
.component 'deleteControl',
  controller: ['$scope', 'Slides', DeleteCtrl]