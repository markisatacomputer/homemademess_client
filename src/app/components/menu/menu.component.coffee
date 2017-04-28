'use strict'

class MenuCtrl
  constructor: ($rootScope, menuService, broadcastService) ->
    this.scope = $rootScope
    this.menuService = menuService
    this.broadcastService = broadcastService
    this.menuOpen = false
    this.trigger = "menu"

  $onInit: () ->
    ctrl = this

    # init menu
    this.getMenu()

    #  menu item ADDED
    this.scope.$on 'menu.add', (e, id) ->
      ctrl.getMenu(true)
    #  menu item REMOVED
    this.scope.$on 'menu.remove', (e, id) ->
      ctrl.getMenu()
    #  menu refresh triggered
    this.scope.$on 'menu.refresh', (e, open) ->
      ctrl.getMenu(open)
    #  slides updated
    this.scope.$on 'slides.update', (e, open) ->
      ctrl.getMenu()

  getMenu: (open) ->
    this.menu = this.menuService.getMenu()
    this.trigger = this.menuService.getTrigger()
    this.menuOpen = open

  #  here's where the action is - ba dum dum
  act: (action) ->
    this.broadcastService.send 'menu.' + action

angular.module 'homemademessClient'
.component 'menu',
  templateUrl: 'app/components/menu/menu.html'
  controller: MenuCtrl
