'use strict'

class MenuActionsCtrl
  constructor: (broadcastService, menuService) ->
    this.broadcastService = broadcastService
    this.menuService = menuService

  $onInit: () ->
    # load menu through menu service
    this.menu = this.menuService.getMenu this.menuname

  #  here's where the action is - ba dum dum
  act: (action) ->
    this.broadcastService.send action

angular.module 'homemademessClient'
.component 'menuActions',
  bindings:
    menuname: '@'
  templateUrl: 'app/components/menu/menuActions.html'
  controller: ['broadcastService', 'menuService', MenuActionsCtrl]
