'use strict'

class SlideActionCtrl
  constructor: (Slides, menuService) ->
    this.Slides = Slides
    this.menuService = menuService
    this.menu = []
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
          label: 'Delete Image'
          src: 'delete'
          action: 'slide.remove'
          states: ['home', 'tagged']
          roles: ['admin']
          direction: 'top'
        }
        {
          label: 'Tag/Untag'
          src: 'add_circle'
          action: 'slide.tag'
          states: ['home', 'tagged']
          roles: ['admin']
          direction: 'top'
        }
        {
          label: 'Edit'
          src: 'edit'
          action: 'slide.edit'
          states: ['home', 'tagged']
          roles: ['admin']
          direction: 'top'
        }
        {
          label: 'Download Original'
          src: 'file_download'
          action: 'slide.download'
          states: ['home', 'tagged']
          roles: ['admin']
          direction: 'top'
        }
        {
          label: 'Close Slideshow'
          src: 'close'
          action: 'slideshow.exit'
          states: ['home', 'tagged']
          roles: ['admin']
          direction: 'top'
        }
      ]

  $onInit: () ->
    ctrl = this

    # register menu
    ctrl.menuService.registerMenu ctrl.menuConfig
    # load menu through menu service
    this.menu = this.menuService.getMenu 'menuSlideAction'


angular.module 'homemademessClient'
.component 'slideAction',
  bindings:
    slide: '<'
  template: '<menu-actions menu="$ctrl.menu">'
  controller: ['Slides', 'menuService', SlideActionCtrl]
