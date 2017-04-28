'use strict'

class SelectedCtrl
  constructor: (selectService, menuService, $scope) ->
    this.selectService = selectService
    this.menuService = menuService
    this.$scope = $scope
    this.menuConfig =
      registerID: 'select'
      filterMenu: (item, itemArray) ->
        if !selectService.isEmpty() and item.select is true then itemArray   #  only show selected actions when something is selected
        else if typeof item.select is 'undefined'
          if item.action is 'selected.deselect' and selectService.isEmpty() then []
          if item.action is 'selected.all'
            allTiles = angular.element(document).find('md-grid-tile')
            selectedTiles = angular.element(allTiles).hasClass('selected')
            console.log allTiles.length, selectedTiles.length
            if allTiles.length is selectedTiles.length then []
          itemArray             #  everything else show
        else []                                                              #  just in case?
      filterTrigger: (currentTrigger) ->
        if selectService.isEmpty() then currentTrigger else "offline_pin"
      menuExtra: [
        {
          label: 'Tag Selected'
          src: 'add_circle'
          action: 'selected.tag'
          states: ['home']
          roles: ['admin']
          select: true
        }
        {
          label: 'Untag Selected'
          src: 'highlight_off'
          action: 'selected.untag'
          states: ['home']
          roles: ['admin']
          select: true
        }
        {
          label: 'Edit Selected'
          src: 'edit'
          action: 'selected.edit'
          states: ['home']
          roles: ['admin']
          select: true
        }
        {
          label: 'Delete Selected'
          src: 'delete'
          action: 'selected.remove'
          states: ['home']
          roles: ['admin']
          select: true
        }
        {
          label: 'Deselect All'
          src: 'select_all'
          action: 'select.none'
          states: ['home']
          roles: ['admin']
        }
        {
          label: 'Select All'
          src: 'done_all'
          action: 'select.all'
          states: ['home']
          roles: ['admin']
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
.component 'selectedControl',
  controller: SelectedCtrl