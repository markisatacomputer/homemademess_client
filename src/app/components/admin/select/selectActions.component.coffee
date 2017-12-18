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

    #  Listen for image deletes
    this.$scope.$on 'image.delete.complete', (e, id) ->
      i = ctrl.selectService.selected.indexOf id
      if i >= 0 then ctrl.selectService.selected.splice i, 1

angular.module 'homemademessClient'
.component 'selectActions',
  controller: ['$scope', '$mdDialog', 'selectService', SelectActionsCtrl]
