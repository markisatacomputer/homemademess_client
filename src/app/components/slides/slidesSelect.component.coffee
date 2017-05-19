'use strict'

class SlidesSelectCtrl
  constructor: ($scope, selectService, Auth) ->
    this.$scope = $scope
    this.selectService = selectService
    this.Auth = Auth

  toggleSelect: (id, value) ->
    i = this.map.indexOf id
    if i > -1
      this.view.images[i].selected = value

  toggleSelectAll: (value) ->
    ctrl = this
    angular.forEach this.view.images, (img, i) ->
      ctrl.view.images[i].selected = value

  drawSelected: () ->
    ctrl = this
    this.selectService.getSelected().then (s) ->
      angular.forEach ctrl.view.images, (img, i) ->
        if s.indexOf(img._id) > -1
          ctrl.view.images[i].selected = true

  $onInit: () ->
    ctrl = this

    #  Map image ids
    this.map = this.view.images.map (i) ->
      return i._id

    #  Draw Selected on page load since slides will come before jwt sometimes
    user = this.Auth.getCurrentUser()
    if user.hasOwnProperty '$promise'
      user.$promise.then (u) ->
        if u.role is 'admin'
          ctrl.drawSelected()

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
      ctrl.drawSelected()

  $onChanges: (changes) ->
    #  Map image ids
    this.map = this.view.images.map (i) ->
      return i._id


angular.module 'homemademessClient'
.component 'slidesSelectControl',
  bindings:
    view: '<'
  controller: SlidesSelectCtrl