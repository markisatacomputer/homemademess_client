'use strict'

class SlidesSelectCtrl
  constructor: ($scope, selectService) ->
    this.$scope = $scope
    this.selectService = selectService

  toggleSelect: (id, value) ->
    i = this.map.indexOf id
    if i > -1
      this.view.images[i].selected = value

  toggleSelectAll: (value) ->
    ctrl = this
    angular.forEach this.view.images, (img, i) ->
      ctrl.view.images[i].selected = value

  $onInit: () ->
    ctrl = this

    #  Map image ids
    this.map = this.view.images.map (i) ->
      return i._id

    #  draw selected images
    this.$scope.$on 'select.on', (e, id) ->
      ctrl.toggleSelect id, true
    this.$scope.$on 'select.off', (e, id) ->
      ctrl.toggleSelect id, false
    this.$scope.$on 'select.all', () ->
      ctrl.toggleSelectAll true
    this.$scope.$on 'select.none', () ->
      ctrl.toggleSelectAll false
    this.$scope.$on 'auth.logout', () ->
      ctrl.toggleSelectAll false
    this.$scope.$on 'auth.login', () ->
      ctrl.selectService.getSelected().then (s) ->
        angular.forEach ctrl.view.images, (img, i) ->
          if s.indexOf(img._id) > -1
            ctrl.view.images[i].selected = true


  $onChanges: (changes) ->
    #  Map image ids
    this.map = this.view.images.map (i) ->
      return i._id


angular.module 'homemademessClient'
.component 'slidesSelectControl',
  bindings:
    view: '<'
  controller: SlidesSelectCtrl