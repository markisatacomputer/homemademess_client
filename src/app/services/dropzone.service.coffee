'use strict'

dropzoneService = (apiUrl, broadcastService, Auth) ->

  headers:
    'Authorization': 'Bearer ' + Auth.getToken()

  init: () ->
    ctrl = this

    #  Add tag header if present
    if this.tag then this.headers.HMMTag = this.tag._id

    #  Construct dropzone
    this.dropzone = new Dropzone 'body',
      url: apiUrl + '/up'
      headers:
        ctrl.headers
      parallelUploads: 1
      previewsContainer: 'upload-info'
      maxFilesize: 999
      timeout: 90000
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

  setHeaders: (headers) ->
    ctrl = this
    angular.forEach headers, (v, k) ->
      ctrl.headers[k] =  v

  removeHeader: (name) ->
    if this.headers[name] then delete this.headers[name]

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