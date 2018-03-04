'use strict'

class DownloadCtrl
  constructor: (menuService) ->
    this.menuService = menuService
    this.menuConfig =
      registerID: 'DownloadCtrl'
      menuSelectAction: [
        {
          label: 'Download Selected Originals'
          src: 'cloud_download'
          action: 'selected.download'
          states: ['home','tagged']
          roles: ['admin']
          direction: 'top'
        }
      ]
      menuSlideAction: [
        {
          label: 'Download Original'
          src: 'file_download'
          action: 'slide.download'
          states: ['home', 'tagged']
          roles: ['admin']
          direction: 'top'
        }
      ]

  $onInit: () ->
    #  add menu
    this.menuService.registerMenu this.menuConfig

angular.module 'homemademessClient'
.component 'downloadControl',
  controller: ['menuService', DownloadCtrl]