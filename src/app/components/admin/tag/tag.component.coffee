'use strict'

class TagCtrl
  constructor: (menuService) ->
    this.menuService = menuService
    this.menuConfig =
      registerID: 'TagCtrl'
      menuSelectAction: [
        {
          label: 'Tag/Untag Selected'
          src: 'add_circle'
          action: 'selected.tag'
          states: ['home']
          roles: ['admin']
          direction: 'top'
        }
      ]

  $onInit: () ->
    #  add menu
    this.menuService.registerMenu this.menuConfig

  $onDestroy: () ->
    # remove menu
    this.menuService.removeMenu this.menuConfig.registerID

angular.module 'homemademessClient'
.component 'tagControl',
  controller: ['menuService', TagCtrl]