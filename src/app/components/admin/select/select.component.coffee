'use strict'

class SelectCtrl
  constructor: (selectService, menuService, $scope) ->
    this.menuService = menuService
    this.$scope = $scope
    this.selectService = selectService

    ctrl = this
    this.menuConfig =
      registerID: 'select'
      filterTrigger: (currentTrigger) ->
        if selectService.isEmpty() then currentTrigger else "offline_pin"
      filterMenu: (item, itemArray, registerID) ->
        if item.action is 'select.all' and registerID is 'select' and !selectService.isEmpty() then return []
        itemArray
      menuMiddle: [
        {
          label: 'Select All (on all pages)'
          src: 'done_all'
          action: 'select.all'
          states: ['home']
          roles: ['admin']
        }
      ]
      menuSelectAction: [
        {
          label: 'Deselect All'
          src: 'select_all'
          action: 'menu.select.none'
          states: ['home']
          roles: ['admin']
          direction: 'top'
        }
        {
          label: 'Select All (on all pages)'
          src: 'done_all'
          action: 'menu.select.all'
          states: ['home']
          roles: ['admin']
          direction: 'top'
        }
      ]

  toggleSelect: (id, value) ->
    i = this.view.map.indexOf id
    if i > -1
      this.view.images[i].selected = value

  toggleSelectAll: (value) ->
    ctrl = this
    angular.forEach this.view.images, (img, i) ->
      ctrl.view.images[i].selected = value

  $onInit: () ->
    ctrl = this

    #register menu
    ctrl.menuService.registerMenu ctrl.menuConfig

    #  init select service
    this.selectService.init().then (s) ->
      #  draw selected
      angular.forEach ctrl.view.images, (img, i) ->
        if ctrl.selectService.selected.indexOf(img._id) > -1
          ctrl.view.images[i].selected = true

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
    this.$scope.$on 'auth.logout', () ->
      ctrl.toggleSelectAll false

  $onDestroy: () ->
    # remove menu
    this.menuService.removeMenu this.menuConfig.registerID

angular.module 'homemademessClient'
.component 'selectControl',
  bindings:
    view: '<'
  templateUrl: 'app/components/admin/select/select.html'
  controller: ['selectService', 'menuService', '$scope', 'Auth', SelectCtrl]
