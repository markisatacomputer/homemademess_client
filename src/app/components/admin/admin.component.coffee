'use strict'

class AdminCtrl

  $onInit: () ->
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
    tag: '<'
  templateUrl: 'app/components/admin/admin.html'
  controller: AdminCtrl