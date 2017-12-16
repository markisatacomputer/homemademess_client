'use strict'

class SlideshowMenuCtrl
  constructor: (menuService, $scope) ->
    this.menuService = menuService
    this.$scope = $scope
    this.bounce = 400   # debounce in ms
    this.menuConfig =
      registerID: 'SlideActionCtrl'
      menuSlideAction: [
        {
          label: 'Image Info'
          src:   'info'
          action:  'slide.toggle.info'
          states: ['home', 'tagged']
          roles: ['admin']
          direction: 'top'
        }
        {
          label: 'Close Slideshow'
          src: 'close'
          action: 'slideshow.exit'
          states: ['home', 'tagged']
          roles: ['admin', 'download', 'anon']
          direction: 'top'
        }
      ]

  $onInit: () ->
    ctrl = this

    # register menu
    ctrl.menuService.registerMenu ctrl.menuConfig

    # actions
    this.$scope.$on 'slideshow.exit', (e) ->
      ctrl.slideshow.showClose()

angular.module 'homemademessClient'
.component 'slideshowMenu',
  require:
    slideshow: '^^'
  controller: ['menuService', '$scope', SlideshowMenuCtrl]
