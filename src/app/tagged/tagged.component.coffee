'use strict'

class TaggedCtrl
  constructor: (menuService, $scope, $state) ->
    this.menuService = menuService
    this.$scope = $scope
    this.$state = $state
    this.menuConfig =
      registerID: 'TaggedCtrl'
      menuExtra: [
        {
          label: 'Home'
          src:   'home'
          action:  'home'
          states: ['tagged']
          roles: ['anon','admin','download']
        }
      ]

  $onInit: ->
    ctrl = this

    #  map images
    this.view.map = this.view.images.map (i) ->
      return i._id

    #  add menu
    this.menuService.registerMenu this.menuConfig

    #  listen for action
    this.$scope.$on 'menu.home', ->
      ctrl.$state.go 'home'

  $onDestroy: ->
    # remove menu
    this.menuService.removeMenu this.menuConfig.registerID

angular.module 'homemademessClient'
.component 'taggedDisplay',
  bindings:
    view: '<'
    user: '<'
    tag: '<'
  templateUrl: 'app/tagged/tagged.html'
  controller: ['menuService', '$scope', '$state', TaggedCtrl]
