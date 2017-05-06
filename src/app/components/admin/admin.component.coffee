'use strict'

class AdminCtrl
  constructor: (socketService, dropzoneService, broadcastService, $scope, Slides) ->
    this.socketService = socketService
    this.dropzoneService = dropzoneService
    this.broadcastService = broadcastService
    this.$scope = $scope
    this.Slides = Slides

  updateView: (postRecieve)->
    ctrl = this
    this.Slides.get {},
    (s) ->
      if postRecieve? then postRecieve s
      #  send slides up
      ctrl.onUpdate {view: s}
    , (e) ->
      ctrl.broadcastService.send 'Slides:error', e

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
          ctrl.socketService.socket.emit 'image:save', item._id
        #  remove dropzone preview - TODO - add animating class rather than removing element entirely
        angular.element(f.previewElement).remove()

  $onInit: () ->
    ctrl = this
    #  INIT SERVICES
    this.dropzoneService.toggle 'init'
    #  resolve socket
    this.socketService.then (s) ->
      ctrl.socketService = s
      #  reload view on when api tells us view has changed
      s.socket.addListener ['images:viewChange'], (imageId) ->
        ctrl.updateView()
    , (e) ->
      console.log e

    #  LISTEN TO SCOPE EVENTS
    #  on successful upload to api, listen for successful upload to cloud
    this.$scope.$on 'dropzone.success', (e, args) ->
      ctrl.addUploadListener args.file, args.res
    #  on delete slide, emit to api, remove from view, return view
    this.$scope.$on 'slide.remove', (e, slide) ->
      ctrl.socketService.socket.emit 'image:remove', slide._id

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