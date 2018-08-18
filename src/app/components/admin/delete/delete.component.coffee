'use strict'

class DeleteCtrl
  constructor: (menuService) ->
    this.menuService = menuService
    this.menuConfig =
      registerID: 'DeleteCtrl'
      menuSelectAction: [
        {
          label: 'Delete Selected'
          src: 'delete'
          action: 'selected.delete'
          states: ['home', 'tagged']
          roles: ['admin']
          direction: 'top'
        }
      ]
      menuSlideAction: [
        {
          label: 'Delete Image'
          src: 'delete'
          action: 'slide.delete'
          states: ['home', 'tagged']
          roles: ['admin']
          direction: 'top'
        }
      ]

  $onInit: () ->
    #  add menu
    this.menuService.registerMenu this.menuConfig

angular.module 'homemademessClient'
.component 'deleteControl',
  controller: ['menuService', DeleteCtrl]