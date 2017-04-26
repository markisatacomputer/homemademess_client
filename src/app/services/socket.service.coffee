'use strict'

angular.module 'homemademessClient'
.factory 'socketService', (socketFactory, apiUrl, Auth, $ocLazyLoad, broadcastService, $q) ->
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


    ###
    Register listeners to sync an array with updates on a model

    Takes the array we want to sync, the model name that socket updates are sent from,
    and an optional callback function after new items are updated.

    @param {String} modelName
    @param {Array} array
    @param {Function} callback
    ###
    syncUpdates: (modelName, array, callback) ->

      ###
      Syncs item creation/updates on 'model:save'
      ###
      this.socket.on modelName + ':save', (item) ->
        oldItem = _.find array,
          _id: item._id

        index = array.indexOf oldItem
        event = 'created'

        # replace oldItem if it exists
        # otherwise just add item to the collection
        if oldItem
          array.splice index, 1, item
          event = 'updated'
        else
          array.push item

        callback? event, item, array

      ###
      Syncs removed items on 'model:remove'
      ###
      this.socket.on modelName + ':remove', (item) ->
        event = 'deleted'
        _.remove array,
          _id: item._id

        callback? event, item, array

    ###
    Register listeners to sync an array with updates on a model

    Takes the array we want to sync, the model name that socket updates are sent from,
    and an optional callback function after new items are updated.

    @param {String} modelName
    @param {Object} obj
    @param {Function} callback
    ###
    syncUpdatesObj: (modelName, obj, callback) ->

      ###
      Syncs item creation/updates on 'model:save'
      ###
      this.socket.on modelName + ':save', (item) ->

        console.log ':save', item
        # replace oldItem if it exists
        # otherwise just add item to the collection
        if obj[item._id]
          event = 'updated'
        else
          event = 'created'
        obj[item._id] = item

        callback? event, item, obj

      ###
      Syncs removed items on 'model:remove'
      ###
      this.socket.on modelName + ':remove', (item) ->
        event = 'deleted'
        delete obj[item._id]

        callback? event, item, obj

    ###
    Removes listeners for a models updates on the socket

    @param modelName
    ###
    unsyncUpdates: (modelName) ->
      this.socket.removeAllListeners modelName + ':save'
      this.socket.removeAllListeners modelName + ':remove'

  #  INIT & RETURN
  socketService.init().then (s) ->
    broadcastService.send 'socket.init', s
    socketService
  , (e) ->
    broadcastService.send 'socket.init.error', e
    e
