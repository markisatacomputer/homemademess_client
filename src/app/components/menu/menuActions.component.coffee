'use strict'

class MenuActionsCtrl
  constructor: (broadcastService) ->
    this.broadcastService = broadcastService

  #  here's where the action is - ba dum dum
  act: (action) ->
    this.broadcastService.send action

angular.module 'homemademessClient'
.component 'menuActions',
  bindings:
    menu: '<'
  templateUrl: 'app/components/menu/menuActions.html'
  controller: ['broadcastService', MenuActionsCtrl]
