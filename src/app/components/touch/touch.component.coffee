'use strict'

class TouchCtrl
  constructor: ($cookies, $window, menuService, $scope) ->
    this.$cookies = $cookies
    this.$window = $window
    this.menuService = menuService
    this.$scope = $scope
    this.menuConfig =
      registerID: 'TouchCtrl'
      menuMiddle: [
        {
          label: 'Upload'
          src: 'cloud_upload'
          action: 'dz-click'
          states: ['home']
          roles: ['admin']
        }
      ]

  $onInit: () ->
    ctrl = this
    #  If touch
    this.touch = this.$cookies.get 'touch'
    if this.touch? then ctrl.firstTouch() else
      this.$window.addEventListener 'touchstart', ->
        ctrl.firstTouch()

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
    this.$cookies.put 'touch', 1
    #  REMOVE touch listener
    this.$window.removeEventListener 'touchstart', this.firstTouch, false
    #  add menu
    this.menuService.registerMenu this.menuConfig


angular.module 'homemademessClient'
.component 'touch',
  controller: ['$cookies', '$window', 'menuService', '$scope', TouchCtrl]