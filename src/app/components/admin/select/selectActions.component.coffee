'use strict'

class SelectActionsCtrl
  constructor: ($scope, $mdDialog, selectService) ->
    this.$scope = $scope
    this.$mdDialog = $mdDialog
    this.selectService = selectService

  $onInit: () ->
    ctrl = this

    #  TAG
    this.$scope.$on 'selected.tag', (e) ->
      ctrl.$mdDialog.show
        templateUrl: 'app/components/admin/tag/tagDialog.html'
        controller: 'TagDialogCtrl'
        controllerAs: 'ctrl'

    #  DELETE
    this.$scope.$on 'selected.delete', (e) ->
      ctrl.$mdDialog.show
        templateUrl: 'app/components/admin/delete/deleteDialog.html'
        controller: 'DeleteDialogCtrl'
        controllerAs: 'ctrl'
        locals:
          images: ctrl.selectService.getSelected()
        bindToController: true

angular.module 'homemademessClient'
.component 'selectActions',
  controller: ['$scope', '$mdDialog', 'selectService', SelectActionsCtrl]