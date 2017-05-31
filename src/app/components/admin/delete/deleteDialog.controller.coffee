'use strict'

class DeleteDialogCtrl
  constructor: (selectService, $mdDialog, $mdMedia) ->
    this.selectService = selectService
    this.$mdDialog = $mdDialog
    this.$mdMedia = $mdMedia

    #  total number of selected images
    this.count = this.selectService.selected.length

    this.cards =
      switch
        when this.$mdMedia 'xs' then 2
        when this.$mdMedia 'sm' then 3
        when this.$mdMedia 'md' then 4
        when this.$mdMedia 'lg' then 6
        when this.$mdMedia 'xl' then 10

    #  additional selected images message
    if this.count > this.cards
      this.additional = 'And ' + (this.count - this.cards) + ' more...'
    else
      this.additional = ''

    console.log this.additional

    #  get first selected images
    ctrl = this
    selectService.getSelectedImages({per: this.cards}).then (imgs) ->
      ctrl.selectedImages = imgs

  removeAll: ->
    ctrl = this
    this.selectService.deleteSelectedImages().then (res) ->
      ctrl.$mdDialog.hide()

angular.module 'homemademessClient'
.controller 'DeleteDialogCtrl', ['selectService', '$mdDialog', '$mdMedia', DeleteDialogCtrl]