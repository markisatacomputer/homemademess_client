'use strict'

class SelectCtrl
  constructor: (selectService, menuService, $scope) ->
    this.menuService = menuService
    this.$scope = $scope
    this.selectService = selectService

  $onInit: () ->
    ctrl = this

    #  slide action
    this.$scope.$on 'slide.select', (e, slide) ->
      ctrl.selectService.toggle slide._id

    #  menu actions
    this.$scope.$on 'menu.select.none', (e) ->
      ctrl.selectService.none()
    this.$scope.$on 'menu.select.all', (e) ->
      ctrl.selectService.all()

    #  init selectService and add menu
    this.selectService.getSelected().then (s) ->
      ctrl.menuConfig =
        registerID: 'select'
        filterMenu: (item, itemArray) ->
          if item.action is 'select.none' and ctrl.selectService.isEmpty() then return []
          if item.action is 'select.all' and ctrl.selectService.isFull(ctrl.view.filter.pagination.count) then return []
          itemArray
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
      ctrl.menuService.registerMenu ctrl.menuConfig

  $onDestroy: () ->
    # remove menu
    this.menuService.removeMenu this.menuConfig.registerID

angular.module 'homemademessClient'
.component 'selectControl',
  bindings:
    view: '<'
  templateUrl: 'app/components/admin/select/select.html'
  controller: SelectCtrl
