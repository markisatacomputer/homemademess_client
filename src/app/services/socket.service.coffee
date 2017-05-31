'use strict'

socketService = (socketFactory, apiUrl, Auth, $ocLazyLoad, broadcastService, $q) ->
  socketService =
    getIO: () ->
      socketService = this
      $q (resolve, reject) ->
        $ocLazyLoad.load apiUrl + '/socket.io-client/socket.io.js'
        .then () ->
          resolve io
        , (e) ->
          reject e

    getSocket: () ->
      socketService = this
      $q (resolve, reject) ->
        if socketService.socket?
          resolve socketService.socket
        else
          socketService.getIO().then (ioc) ->
            ioSocket = ioc apiUrl,
              query: 'token=' + Auth.getToken() # Send auth token on connection
              path: '/socket.io-client'

            ioSocket.on 'connect', ->
              socketService.socket = socketFactory ioSocket: ioSocket
              resolve socketService.socket
          , (e) ->
            reject e

    init: () ->
      socketService = this
      $q (resolve, reject) ->
        socketService.getSocket().then (sock) ->
          resolve socketService
        , (e) ->
          reject e

    destroy: () ->
      if this.socket?.close?
        this.socket.close()
        this.socket = undefined
        broadcastService.send 'socket.close'

    registerListener: (name, func) ->
      ctrl = this
      #  allow adding the same callback to several different events
      if !Array.isArray name
        name = [name]
      name.forEach (n) ->
        this.socket.on n, (data)->
          ctrl.broadcastService n, data
          if func? then func data
        broadcastService.send 'socket.registerListener', name

    emit: (name, data) ->
      this.socket.emit name, data
      broadcastService.send 'socket.emit', name, data

  #  INIT & RETURN
  socketService.init().then (s) ->
    broadcastService.send 'socket.init', s
    socketService
  , (e) ->
    broadcastService.send 'socket.init.error', e
    e

angular.module 'homemademessClient'
.factory 'socketService', ['socketFactory', 'apiUrl', 'Auth', '$ocLazyLoad', 'broadcastService', '$q', socketService]
