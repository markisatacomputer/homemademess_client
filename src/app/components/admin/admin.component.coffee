'use strict'

class AdminCtrl
  constructor: (socketService, dropzoneService, $scope, Auth) ->
    this.socketService = socketService
    this.dropzoneService = dropzoneService
    this.$scope = $scope
    this.Auth = Auth

  initAdmin: () ->
    #  wait for user
    if this.user?.$promise?
      ctrl = this
      ctrl.user.$promise.then () ->
        if ctrl.user.role? and ctrl.user.role == 'admin'
          ctrl.onAdmin()
        else
          ctrl.onNotAdmin()

    #  check if user is admin
    else
      if this.user?.role? and this.user.role == 'admin'
        this.onAdmin()
      else
        this.onNotAdmin()

  #  user is admin
  onAdmin: () ->
    this.dropzoneService.toggle 'init'
    this.socketService.init()

  #  user is not admin
  onNotAdmin: () ->
    this.dropzoneService.toggle 'destroy'
    this.socketService.destroy()

  $onInit: () ->
    this.initAdmin this.user

  $onChanges: (changes) ->
    this.initAdmin this.user

  #$onDestroy: () ->
    #this.dropzoneService.toggle 'destroy'

angular.module 'homemademessClient'
.component 'admin',
  bindings:
    user: '<'
    onUpdate: '&'
  templateUrl: 'app/components/admin/admin.html'
  controller: AdminCtrl