'use strict'

class AdminCtrl
  constructor: (socketService, dropzoneService, $rootScope, Auth) ->
    this.socketService = socketService
    this.dropzoneService = dropzoneService
    this.$scope = $rootScope
    this.Auth = Auth
    this.uploads = []

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
    ctrl = this
    this.dropzoneService.toggle 'init'
    this.socketService.init()

  #  user is not admin
  onNotAdmin: () ->
    this.dropzoneService.toggle 'destroy'
    this.socketService.destroy()

  addUploadListener: (f, res) ->
    ctrl = this
    #  on successful upload to api, listen for successful upload to cloud
    if res._id? and ctrl.socketService.socket?
      #  Progress - TODO
      ctrl.socketService.socket.on res._id+':progress', (progress, total) ->
        console.log res._id+':progress', progress, total
      #  Complete
      ctrl.socketService.socket.on res._id+':complete', (item) ->
        #  push new image into view.images - TODO : fix slideshow re: this
        ctrl.view.images.unshift item
        ctrl.onUpdate ctrl.view
        #  save image from temp cleanup
        if item.createDate != 0
          ctrl.socketService.socket.emit 'image:save', item._id
        #  remove dropzone preview
        #  TODO - add animating class rather than removing element entirely
        angular.element(f.previewElement).remove()

  $onInit: () ->
    ctrl = this
    this.initAdmin this.user
    #  on successful upload to api, listen for successful upload to cloud
    this.$scope.$on 'dropzone.success', (e, args) ->
      ctrl.addUploadListener args.file, args.res

  $onChanges: (changes) ->
    this.initAdmin this.user

  #$onDestroy: () ->
    #this.dropzoneService.toggle 'destroy'

angular.module 'homemademessClient'
.component 'admin',
  bindings:
    user: '<'
    view: '<'
    onUpdate: '&'
  templateUrl: 'app/components/admin/admin.html'
  controller: AdminCtrl