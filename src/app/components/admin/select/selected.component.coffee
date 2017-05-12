'use strict'

class SelectCtrl
  constructor: (selectService, menuService, $scope, $mdDialog) ->
    ctrl = this
    this.selectService = selectService
    this.menuService = menuService
    this.$scope = $scope
    this.$mdDialog = $mdDialog
    this.menuConfig =
      registerID: 'select'
      filterMenu: (item, itemArray) ->
        if typeof item.select is true
          if item.action is 'select.none' and ctrl.selectService.isEmpty()
            console.log 'nope'
            return []
          if item.action is 'select.all' and ctrl.selectService.isFull() then return []
        itemArray
      filterTrigger: (currentTrigger) ->
        if selectService.isEmpty() then currentTrigger else "offline_pin"
      menuExtra: [
        {
          label: 'Deselect All'
          src: 'select_all'
          action: 'select.none'
          states: ['home']
          roles: ['admin']
          select: true
        }
        {
          label: 'Select All (on all pages)'
          src: 'done_all'
          action: 'select.all'
          states: ['home']
          roles: ['admin']
          select: true
        }
      ]

  #  get array of ids for all unselected images in current view
  toggleSelectedInView: (select)->
    allEl = angular.element(document).find('md-grid-tile')
    all = []
    ctrl = this
    saveSelectState = (el) ->
      id = angular.element(el).attr 'id'
      if select and ctrl.selectService.selected.indexOf(id) > -1 then ctrl.selectService.toggle id
      if not select and ctrl.selectService.selected.indexOf(id) is -1 then ctrl.selectService.toggle id

    saveSelectState tile for tile in allEl

  $onInit: () ->
    ctrl = this

    #  add menu
    this.menuService.registerMenu this.menuConfig

    #  Menu and Slide ACTIONS
    #  slide single select button event
    this.$scope.$on 'slide.select', (e, slide) ->
      ctrl.selectService.toggle slide._id
    #  menu selected action events
    this.$scope.$on 'menu.select.none', (e) ->
      ctrl.toggleSelectedInView true
    this.$scope.$on 'menu.select.all', (e) ->
      ctrl.toggleSelectedInView false

    #  Event REACTIONS
    #  slides update
    this.$scope.$on 'slides.layout', (e) ->
      ctrl.selectService.emitSelections()
    #  select service events
    this.$scope.$on 'select.on', (e, id) ->
      angular.element(document.getElementById(id)).addClass('selected')
    this.$scope.$on 'select.off', (e, id) ->
      angular.element(document.getElementById(id)).removeClass('selected')
    this.$scope.$on 'select.has-selected', (e) ->
      angular.element(document).find('body').addClass('has-selected')
    this.$scope.$on 'select.empty', (e) ->
      angular.element(document).find('body').removeClass('has-selected')

    #  init css classes
    ctrl.selectService.emitSelections()

  $onDestroy: () ->
    # remove css classes
    angular.forEach this.selectService.selected, (id, i) ->
      angular.element(document.getElementById(id)).removeClass('selected')
    angular.element(document).find('body').removeClass('has-selected')
    # remove menu
    this.menuService.removeMenu this.menuConfig.registerID

angular.module 'homemademessClient'
.component 'selectControl',
  bindings:
    view: '<'
  templateUrl: 'app/components/admin/select/select.html'
  controller: SelectCtrl
