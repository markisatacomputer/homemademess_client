'use strict'

class SelectedCtrl
  constructor: (broadcastService, selectService, menuService, $rootScope) ->
    this.broadcastService = broadcastService
    this.selectService = selectService
    this.menuService = menuService
    this.$scope = $rootScope
    this.menuConfig =
      registerID: 'select'
      filterMenu: (item, itemArray) ->
        if !selectService.isEmpty() and item.select is true then itemArray   #  only show selected actions when something is selected
        else if typeof item.select is 'undefined' then itemArray             #  everything else show
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
          action: 'selected.deselect'
          states: ['home']
          roles: ['admin']
        }
        {
          label: 'Select All'
          src: 'done_all'
          action: 'selected.all'
          states: ['home']
          roles: ['admin']
        }
      ]

  clssSelected: (add)->
    if !add? then add = true
    selected = this.selectService.getSelected()

    if add and !this.selectService.isEmpty()
      angular.forEach selected, (id, i) ->
        angular.element(document.getElementById(id)).addClass('selected')
      angular.element(document).find('body').addClass('has-selected')
    else
      angular.forEach selected, (id, i) ->
        angular.element(document.getElementById(id)).removeClass('selected')
      angular.element(document).find('body').removeClass('has-selected')

  toggleSelectInView: (selected) ->
    all = this.selectService.getSelectedInView selected
    this.selectService.toggle id for id in all
    this.broadcastService.send 'menu.refresh', !selected

  $onInit: () ->
    ctrl = this

    #  add menu
    this.menuService.registerMenu this.menuConfig

    #  slide single select button event
    this.$scope.$on 'slide.select', (e, slide) ->
      ctrl.selectService.toggle slide._id

    #  select service events
    this.$scope.$on 'select.on', (e, id) ->
      angular.element(document.getElementById(id)).addClass('selected')
    this.$scope.$on 'select.off', (e, id) ->
      angular.element(document.getElementById(id)).removeClass('selected')
    this.$scope.$on 'select.has-selected', (e) ->
      angular.element(document).find('body').addClass('has-selected')
      ctrl.broadcastService.send 'menu.refresh', true
    this.$scope.$on 'select.empty', (e) ->
      angular.element(document).find('body').removeClass('has-selected')
      ctrl.broadcastService.send 'menu.refresh', false

    #  menu selected action events
    this.$scope.$on 'menu.selected.deselect', (e) ->
      ctrl.toggleSelectInView true
    this.$scope.$on 'menu.selected.all', (e) ->
      ctrl.toggleSelectInView false

    #  on slides change, class
    this.$scope.$on 'slidesLayout', (e) ->
      ctrl.clssSelected()

  $onDestroy: () ->
    this.clssSelected false

angular.module 'homemademessClient'
.component 'selectedControl',
  controller: SelectedCtrl