'use strict'

class EditCtrl
  constructor: (menuService, $scope, $mdDialog) ->
    this.menuService = menuService
    this.$scope = $scope
    this.$mdDialog = $mdDialog
    this.menuConfig =
      registerID: 'EditCtrl'
      menuExtra: [
        {
          label: 'Edit Selected'
          src: 'edit'
          action: 'selected.edit'
          states: ['home']
          roles: ['admin']
        }
      ]

  $onInit: () ->
    ctrl = this

    #  add menu
    this.menuService.registerMenu this.menuConfig

    #  ACTION
    this.$scope.$on 'menu.selected.edit', (e) ->
      ctrl.$mdDialog.show
        clickOutsideToClose: true
        templateUrl: 'app/components/admin/edit/editDialog.html'
        controller: 'EditDialogCtrl'
        controllerAs: 'ctrl'
        locals:
          selectedImages: ctrl.selectService.selected
        bindToController: true

  $onDestroy: () ->
    # remove menu
    this.menuService.removeMenu this.menuConfig.registerID

angular.module 'homemademessClient'
.component 'editControl',
  controller: ['menuService', '$scope', '$mdDialog', EditCtrl]