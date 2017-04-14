'use strict'

angular.module 'homemademessClient'
.factory 'dropzoneService', (apiUrl, broadcastService) ->

  init: () ->
    this.dropzone = new Dropzone 'body',
      url: apiUrl + '/up'
      headers:
        "Test-Header": "This is a test."
      createImageThumbnails: false
      autoProcessQueue: true
      previewsContainer: 'upload-info'
      init: () ->
        this.on 'drop', (e) ->
          broadcastService.send 'dropzone.drop', e
        this.on 'addedfile', (f) ->
          broadcastService.send 'dropzone.addedfile', f
        this.on 'success', (f, res) ->
          broadcastService.send 'dropzone.success', f
        this.on 'error', (f, msg) ->
          console.log 'error', f, msg
          broadcastService.send 'dropzone.error', f
        this.on 'canceled', (f) ->
          console.log 'canceled', f
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
          console.log 'dropzone.destroy'
          if !this.dropzone?
            broadcastService.send 'dropzone.destroy'
