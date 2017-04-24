'use strict'

class AdminCtrl
  constructor: (socketService, dropzoneService, $rootScope, Auth) ->
    this.socketService = socketService
    this.dropzoneService = dropzoneService
    this.$scope = $rootScope
    this.Auth = Auth
    this.uploads = []

  addUploadListener: (f, res) ->
    ctrl = this
    #  on successful upload to api, listen for successful upload to cloud
    if res._id? and ctrl.socketService.socket?
      #  Progress - TODO
      ctrl.socketService.socket.on res._id+':progress', (progress, total) ->
        console.log res._id+':progress', progress, total
      #  Complete
      ctrl.socketService.socket.on res._id+':complete', (item) ->
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
    this.dropzoneService.toggle 'init'
    this.socketService.init()
    #  on successful upload to api, listen for successful upload to cloud
    this.$scope.$on 'dropzone.success', (e, args) ->
      ctrl.addUploadListener args.file, args.res

  $onDestroy: () ->
    this.dropzoneService.toggle 'destroy'
    this.socketService.destroy()

angular.module 'homemademessClient'
.component 'admin',
  bindings:
    user: '<'
    view: '<'
    onUpdate: '&'
  templateUrl: 'app/components/admin/admin.html'
  controller: AdminCtrl