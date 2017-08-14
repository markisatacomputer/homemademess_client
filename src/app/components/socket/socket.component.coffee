'use strict'

class SocketCtrl
  constructor: (socketService, broadcastService, $scope) ->
    this.socketService = socketService
    this.broadcastService = broadcastService
    this.$scope = $scope

  $onInit: () ->
    ctrl = this

    #  BRAODCAST socket events to app
    this.socketService.then (s) ->
      #  image in process of deletion
      s.socket.on 'image:delete:begin', (id) ->
        ctrl.broadcastService.send 'image.delete.begin', id

      #  delete operation successful
      s.socket.on 'image:delete:complete', (id) ->
        ctrl.broadcastService.send 'image.delete.complete', id

      #  after upload to api, upload to cloud begins
      s.socket.on 'image:upload:begin', (img) ->
        ctrl.broadcastService.send 'image.upload.begin', img

      #  processing/upload to cloud successful
      s.socket.on 'image:upload:complete', (img) ->
        ctrl.broadcastService.send 'image.upload.complete', img


angular.module 'homemademessClient'
.component 'socket',
  controller: ['socketService', 'broadcastService', '$scope', SocketCtrl]