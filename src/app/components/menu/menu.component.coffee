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
      ctrl.getMenu true
    #  menu item REMOVED
    this.scope.$on 'menu.remove', (e, id) ->
      ctrl.getMenu()
    #  selection changes
    this.scope.$on 'menu.reload', (e, open) ->
      ctrl.getMenu open

    #  user changed
    this.scope.$on 'auth.login', (e, user) ->
      ctrl.getMenu true
    this.scope.$on 'auth.logout', (e, user) ->
      ctrl.getMenu()

  getMenu: (open) ->
    this.menu = this.menuService.getMenu()
    this.trigger = this.menuService.getTrigger()
    this.menuOpen = if typeof(open) is "boolean" then open else this.menuOpen

  #  here's where the action is - ba dum dum
  act: (action) ->
    this.broadcastService.send 'menu.' + action

angular.module 'homemademessClient'
.component 'menu',
  templateUrl: 'app/components/menu/menu.html'
  controller: ['$rootScope', 'menuService', 'broadcastService', MenuCtrl]
