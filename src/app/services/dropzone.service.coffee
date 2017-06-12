'use strict'

dropzoneService = (apiUrl, broadcastService, Auth) ->

  init: () ->
    ctrl = this
    this.dropzone = new Dropzone 'body',
      url: apiUrl + '/up'
      headers:
        'Authorization': 'Bearer ' + Auth.getToken()
      parallelUploads: 1
      acceptedFiles: 'image/*'
      previewsContainer: 'upload-info'
      init: () ->
        this.on 'drop', (e) ->
          ctrl.update()
          broadcastService.send 'dropzone.drop', e
        this.on 'addedfile', (f) ->
          ctrl.update()
          broadcastService.send 'dropzone.addedfile', f
        this.on 'success', (f, res) ->
          ctrl.update()
          broadcastService.send 'dropzone.success', {file: f, res: res}
        this.on 'error', (f, msg) ->
          ctrl.update()
          broadcastService.send 'dropzone.error', {file: f, msg: msg}
        this.on 'canceled', (f) ->
          ctrl.update()
          broadcastService.send 'dropzone.canceled', f
        this.on 'removedfile', (f) ->
          ctrl.update()
          broadcastService.send 'dropzone.removedfile', f
        this.on 'totaluploadprogress', (total, totalBytes, totalSent) ->
          broadcastService.send 'dropzone.progress', total
        this.on 'queuecomplete', () ->
          broadcastService.send 'dropzone.queuecomplete', arguments

    if this.dropzone?
      broadcastService.send 'dropzone.init'

  destroy: () ->
    this.dropzone.destroy()
    this.dropzone = undefined

  update: () ->
    broadcastService.send 'dropzone.update',
      processing: this.dropzone.getAcceptedFiles()
      rejected: this.dropzone.getRejectedFiles()
      queued: this.dropzone.getQueuedFiles()
      uploading: this.dropzone.getUploadingFiles()

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