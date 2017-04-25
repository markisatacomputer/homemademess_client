'use strict'

class AdminCtrl
  constructor: (socketService, dropzoneService, broadcastService, selectService, $rootScope, Slides) ->
    this.socketService = socketService
    this.dropzoneService = dropzoneService
    this.broadcastService = broadcastService
    this.selectService = selectService
    this.$scope = $rootScope
    this.Slides = Slides
    this.uploads = []

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
    this.socketService.init().then (s) ->
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

    #  select events
    this.$scope.$on 'slide.select', (e, slide) ->
      ctrl.selectService.toggle slide._id
    this.$scope.$on 'select.on', (e, id) ->
      angular.element(document).find('body').addClass('has-selected')
      angular.element(document.getElementById(id)).addClass('selected')
    this.$scope.$on 'select.off', (e, id) ->
      angular.element(document.getElementById(id)).removeClass('selected')
    this.$scope.$on 'select.empty', (e, id) ->
      angular.element(document).find('body').removeClass('has-selected')
    this.$scope.$on 'slidesLayout', (e) ->
      selected = ctrl.selectService.getSelected()
      console.log selected
      angular.forEach selected, (id, i) ->
        angular.element(document.getElementById(id)).addClass('selected')

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