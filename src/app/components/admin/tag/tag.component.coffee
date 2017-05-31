'use strict'

class TagCtrl
  constructor: (menuService, $scope, $mdDialog) ->
    this.menuService = menuService
    this.$scope = $scope
    this.$mdDialog = $mdDialog
    this.menuConfig =
      registerID: 'TagCtrl'
      menuExtra: [
        {
          label: 'Tag/Untag Selected'
          src: 'add_circle'
          action: 'selected.tag'
          states: ['home']
          roles: ['admin']
        }
      ]

  $onInit: () ->
    ctrl = this

    #  add menu
    this.menuService.registerMenu this.menuConfig

    #  ACTION
    this.$scope.$on 'menu.selected.tag', (e) ->
      ctrl.$mdDialog.show
        clickOutsideToClose: true
        templateUrl: '/app/components/admin/tag/tagDialog.html'
        controller: 'TagDialogCtrl'
        controllerAs: 'ctrl'

  $onDestroy: () ->
    # remove menu
    this.menuService.removeMenu this.menuConfig.registerID

angular.module 'homemademessClient'
.component 'tagControl',
  controller: ['menuService', '$scope', '$mdDialog', TagCtrl]