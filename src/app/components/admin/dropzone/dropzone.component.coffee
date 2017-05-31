'use strict'

class DZCtrl
  constructor: (dropzoneService, $scope) ->
    this.dropzoneService = dropzoneService
    this.$scope = $scope

  $onInit: () ->
    ctrl = this
    #  INIT SERVICES
    this.dropzoneService.toggle 'init'

    #  LISTEN TO SCOPE EVENTS
    #  on successful upload to api, add record id to the element
    this.$scope.$on 'dropzone.success', (e, args) ->
      angular.element(args.file.previewElement).attr 'id', 'dz-' + args.res._id

  $onDestroy: () ->
    #  REMOVE SERVICES
    this.dropzoneService.toggle 'destroy'

angular.module 'homemademessClient'
.component 'dropzone',
  template: '<upload-info></upload-info>'
  controller: ['dropzoneService', '$scope', DZCtrl]