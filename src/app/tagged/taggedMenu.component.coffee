'use strict'

class TaggedMenuCtrl
  constructor: (menuService, $scope, $state) ->
    this.menuService = menuService
    this.$scope = $scope
    this.$state = $state
    this.bounce = 400   # debounce in ms
    this.menuConfig =
      registerID: 'TaggedState'
      menuMiddle: [
        {
          label: 'Return'
          src:   'arrow_back'
          action:  'home'
          states: ['tagged']
          roles: ['anon','admin','download']
        }
      ]

  $onInit: () ->
    ctrl = this

    # register menu
    ctrl.menuService.registerMenu ctrl.menuConfig

    # actions
    this.$scope.$on 'menu.home', ->
      ctrl.$state.go 'home', ctrl.previous

  $onDestroy: ->
    # remove menu
    this.menuService.removeMenu this.menuConfig.registerID

angular.module 'homemademessClient'
.component 'taggedMenu',
  bindings:
    previous: '<'
  controller: ['menuService', '$scope', '$state', TaggedMenuCtrl]
