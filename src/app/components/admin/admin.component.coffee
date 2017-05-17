'use strict'

class AdminCtrl
  constructor: (broadcastService, $scope, menuService) ->
    this.broadcastService = broadcastService
    this.$scope = $scope
    this.menuService = menuService

  $onInit: () ->
    ctrl = this
    #  ADD CLASSES
    angular.element(document).find('body').addClass('user-'+this.user.name)
    angular.element(document).find('body').addClass('role-admin')

  $onDestroy: () ->
    #  REMOVE CLASSES
    angular.element(document).find('body').removeClass('user-'+this.user.name)
    angular.element(document).find('body').removeClass('role-admin')

angular.module 'homemademessClient'
.component 'admin',
  bindings:
    user: '<'
    view: '<'
    onUpdate: '&'
  templateUrl: 'app/components/admin/admin.html'
  controller: AdminCtrl