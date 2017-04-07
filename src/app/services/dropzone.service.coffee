'use strict'

angular.module 'homemademessClient'
.factory 'dropzoneService', (apiUrl, broadcastService, socketService) ->

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
          console.log e
          broadcastService.send 'dropzone.drop', e
        this.on 'addedfile', (f) ->
          console.log f
          broadcastService.send 'dropzone.addedfile', f
        this.on 'success', (f, res) ->

      #drop: (e) ->
      #  console.log e
      #addedfile: (f) ->
      #  console.log f
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
          console.log 'dropzone.init'
          if this.dropzone?
            broadcastService.send 'dropzone.init'
      when 'destroy'
        if this.dropzone?
          this.destroy()
          console.log 'dropzone.destroy'
          if !this.dropzone?
            broadcastService.send 'dropzone.destroy'
