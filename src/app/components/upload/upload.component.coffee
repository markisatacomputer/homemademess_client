'use strict'

class UploadCtrl
  constructor: (dropzoneService, $scope, Auth) ->
    this.dropzoneService = dropzoneService
    this.$scope = $scope
    this.Auth = Auth

  initZone: () ->
    if this.user?.$promise?
      ctrl = this
      ctrl.user.$promise.then () ->
        if ctrl.user.role? and ctrl.user.role == 'admin'
          ctrl.dropzoneService.toggle 'init'
    else
      if this.user?.role? and this.user.role == 'admin'
        this.dropzoneService.toggle 'init'

  $onInit: () ->
    #  on init check if user is admin
    this.initZone this.user

  $onChanges: (changes) ->
    #  wait for user
    this.initZone this.user



  $onDestroy: () ->
    #console.log this.dropzone
    this.dropzoneService.toggle 'destroy'

angular.module 'homemademessClient'
.component 'upload',
  bindings:
    user: '<'
    onUpdate: '&'
  template: '<upload-control></upload-control><upload-info></upload-info>'
  controller: UploadCtrl