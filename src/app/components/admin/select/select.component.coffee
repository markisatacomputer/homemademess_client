'use strict'

class SelectCtrl
  constructor: (selectService, menuService, $scope, Auth) ->
    this.menuService = menuService
    this.$scope = $scope
    this.selectService = selectService
    this.Auth = Auth

    ctrl = this
    this.menuConfig =
      registerID: 'select'
      filterTrigger: (currentTrigger) ->
        if ctrl.selectService.isEmpty() then currentTrigger else "offline_pin"
      menuExtra: [
        {
          label: 'Deselect All'
          src: 'select_all'
          action: 'select.none'
          states: ['home']
          roles: ['admin']
        }
        {
          label: 'Select All (on all pages)'
          src: 'done_all'
          action: 'select.all'
          states: ['home']
          roles: ['admin']
        }
      ]

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

    #  slide action
    this.$scope.$on 'slide.select', (e, slide) ->
      ctrl.selectService.toggle slide._id

    #  menu actions
    this.$scope.$on 'menu.select.none', (e) ->
      ctrl.selectService.none()
    this.$scope.$on 'menu.select.all', (e) ->
      ctrl.selectService.all()

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

    #  init selectService and add menu
    this.selectService.getSelected().then (s) ->
      ctrl.menuConfig.filterMenu = (item, itemArray) ->
        if item.action is 'select.none' and ctrl.selectService.isEmpty() then return []
        if item.action is 'select.all' and ctrl.selectService.isFull(ctrl.view.filter.pagination.count) then return []
        itemArray
      ctrl.menuService.registerMenu ctrl.menuConfig

  $onChanges: (changes) ->
    #  Map image ids
    this.map = this.view.images.map (i) ->
      return i._id

  $onDestroy: () ->
    # remove menu
    this.menuService.removeMenu this.menuConfig.registerID

angular.module 'homemademessClient'
.component 'selectControl',
  bindings:
    view: '<'
  templateUrl: 'app/components/admin/select/select.html'
  controller: SelectCtrl
