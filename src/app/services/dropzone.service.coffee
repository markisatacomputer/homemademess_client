'use strict'

dropzoneService = (apiUrl, broadcastService, Auth) ->

  init: () ->
    this.dropzone = new Dropzone 'body',
      url: apiUrl + '/up'
      headers:
        'Authorization': 'Bearer ' + Auth.getToken()
      autoProcessQueue: true
      previewsContainer: 'upload-info'
      init: () ->
        this.on 'drop', (e) ->
          broadcastService.send 'dropzone.drop', e
        this.on 'addedfile', (f) ->
          broadcastService.send 'dropzone.addedfile', f
        this.on 'success', (f, res) ->
          broadcastService.send 'dropzone.success', {file: f, res: res}
        this.on 'error', (f, msg) ->
          broadcastService.send 'dropzone.error', {file: f, msg: msg}
        this.on 'canceled', (f) ->
          broadcastService.send 'dropzone.canceled', f

    if this.dropzone?
      broadcastService.send 'dropzone.init'

  destroy: () ->
    this.dropzone.destroy()
    this.dropzone = undefined

  toggle: (op) ->
    #  set operation
    if !op?
      if this.dropzone?
        op = 'destroy'
      else
        op = 'init'

    switch op
      when 'init'
        if !this.dropzone?
          this.init()
          if this.dropzone?
            broadcastService.send 'dropzone.init'
      when 'destroy'
        if this.dropzone?
          this.destroy()
          if !this.dropzone?
            broadcastService.send 'dropzone.destroy'

angular.module 'homemademessClient'
.factory 'dropzoneService', ['apiUrl', 'broadcastService', 'Auth', dropzoneService]