'use strict'

class DZCtrl
  constructor: (dropzoneService, broadcastService, queueService, $scope) ->
    this.dropzoneService = dropzoneService
    this.broadcastService = broadcastService
    this.queueService = queueService
    this.$scope = $scope
    this.processing = []
    this.rejected = []
    this.queued = []
    this.uploading = []
    this.total = 0
    this.showpreviews = true
    this.selectoncomplete = false
    this.inprocess = false

  $onInit: () ->
    ctrl = this

    #  INIT SERVICES
    if this.tag?[0]?
      this.dropzoneService.setHeaders { 'HMM-Tag' : ctrl.tag[0]._id }
    this.dropzoneService.toggle 'init'
    this.queueService.get().then (q) ->
      console.log 'q', q

    #  LISTEN TO SCOPE EVENTS
    #  on successful upload to api, add record id to the element
    this.$scope.$on 'dropzone.success', (e, args) ->
      angular.element(args.file.previewElement).attr 'id', 'dz-' + args.res.Key
    #  map values to component
    this.$scope.$on 'dropzone.update', (e, args) ->
      angular.forEach args, (arg, key) ->
        ctrl[key] = arg
      ctrl.$scope.$apply()
    #  show dropzone progress
    this.$scope.$on 'dropzone.progress', (e, total) ->
      ctrl.total = total

    #  upload complete, process begins
    this.$scope.$on 'image.upload.init', (e, img) ->
      ctrl.inprocess = img
    #  upload and process complete
    this.$scope.$on 'image.upload.complete', (e, img) ->
      #  remove from dropzone
      angular.forEach ctrl.processing, (file, i) ->
        if file.name is img.filename
          ctrl.dropzoneService.dropzone.removeFile file
      #  select
      if ctrl.selectoncomplete
        ctrl.broadcastService.send 'slide.select', img

  $onDestroy: () ->
    #  REMOVE SERVICES
    this.dropzoneService.toggle 'destroy'

angular.module 'homemademessClient'
.component 'dropzone',
  templateUrl: 'app/components/admin/dropzone/dropzone.html'
  bindings:
    tag: '<'
  controller: ['dropzoneService', 'broadcastService', 'queueService', '$scope', DZCtrl]