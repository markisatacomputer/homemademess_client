'use strict'

class TouchCtrl
  constructor: (touchService, $window, menuService, $scope) ->
    this.touchService = touchService
    this.$window = $window
    this.menuService = menuService
    this.$scope = $scope
    this.menuConfig =
      registerID: 'TouchCtrl'
      menuExtra: [
        {
          label: 'Upload'
          src: 'cloud_upload'
          action: 'dz-click'
          states: ['home']
          roles: ['admin']
        }
      ]

  $onInit: () ->
    #  If touch
    this.touch = this.touchService.get
    if this.touch then this.firstTouch() else
      this.$window.addEventListener 'touchstart', this.firstTouch

    #  react to touchscreen upload menu item
    this.$scope.$on 'menu.dz-click', () ->
      document.querySelector('.dz-hidden-input').click()

  $onDestroy: () ->
    #  REMOVE touch listener
    this.$window.removeEventListener 'touchstart', this.firstTouch, false
    # remove menu
    this.menuService.removeMenu this.menuConfig.registerID

  #  When touch, store
  firstTouch: ->
    #  CSS
    angular.element(document.body).addClass 'touch'
    #  Cookie storage
    this.touchService.store true
    #  REMOVE touch listener
    this.$window.removeEventListener 'touchstart', this.firstTouch, false
    #  add menu
    this.menuService.registerMenu this.menuConfig


angular.module 'homemademessClient'
.component 'touch',
  controller: ['touchService', '$window', 'menuService', '$scope', TouchCtrl]