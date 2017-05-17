'use strict'

class DZCtrl
  constructor: (socketService, dropzoneService, $scope) ->
    ctrl = this
    socketService.then (s) ->
      ctrl.socketService = s
    this.dropzoneService = dropzoneService
    this.$scope = $scope

  #  Dropzone Listeners
  addUploadListener: (f, res) ->
    ctrl = this
    if res._id? and ctrl.socketService.socket?
      #  Upload Progress - TODO
      ctrl.socketService.socket.on res._id+':progress', (progress, total) ->
        console.log res._id+':progress', progress, total
      #  Upload Complete
      ctrl.socketService.socket.on res._id+':complete', (item) ->
        #  save image from temp cleanup
        if item.createDate != 0
          ctrl.socketService.emit 'image:save', item._id
        #  remove dropzone preview - TODO - add animating class rather than removing element entirely
        angular.element(f.previewElement).remove()

  $onInit: () ->
    ctrl = this
    #  INIT SERVICES
    this.dropzoneService.toggle 'init'

    #  LISTEN TO SCOPE EVENTS
    #  on successful upload to api, listen for successful upload to cloud
    this.$scope.$on 'dropzone.success', (e, args) ->
      ctrl.addUploadListener args.file, args.res

  $onDestroy: () ->
    #  REMOVE SERVICES
    this.dropzoneService.toggle 'destroy'

angular.module 'homemademessClient'
.component 'dropzone',
  template: '<upload-info></upload-info>'
  controller: DZCtrl