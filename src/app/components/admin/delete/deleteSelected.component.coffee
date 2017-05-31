'use strict'

class DeleteSelectedCtrl
  constructor: (menuService, $scope, $mdDialog) ->
    this.menuService = menuService
    this.$scope = $scope
    this.$mdDialog = $mdDialog
    this.menuConfig =
      registerID: 'DeleteCtrl'
      menuExtra: [
        {
          label: 'Delete Selected'
          src: 'delete'
          action: 'selected.remove'
          states: ['home']
          roles: ['admin']
        }
      ]

  $onInit: () ->
    ctrl = this

    #  add menu
    this.menuService.registerMenu this.menuConfig

    #  ACTION
    this.$scope.$on 'menu.selected.remove', (e) ->
      ctrl.$mdDialog.show
        clickOutsideToClose: true
        templateUrl: '/app/components/admin/delete/deleteDialog.html'
        controller: 'DeleteDialogCtrl'
        controllerAs: 'ctrl'

  $onDestroy: () ->
    # remove menu
    this.menuService.removeMenu this.menuConfig.registerID

angular.module 'homemademessClient'
.component 'deleteSelectedControl',
  controller: ['menuService', '$scope', '$mdDialog', DeleteSelectedCtrl]