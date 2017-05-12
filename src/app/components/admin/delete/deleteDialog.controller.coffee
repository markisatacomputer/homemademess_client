'use strict'

class DeleteDialogCtrl
  constructor: (socketService, selectService, $mdDialog) ->
    ctrl = this
    socketService.then (s) ->
      ctrl.socketService = s

    this.selectService = selectService
    this.$mdDialog = $mdDialog

  deleteAll: ->
    ctrl = this
    #  save new tags
    angular.forEach this.selectedService.selected, (imgId, i) ->
      ctrl.socketService.emit 'image.remove', imgId

angular.module 'homemademessClient'
.controller 'DeleteDialogCtrl', DeleteDialogCtrl