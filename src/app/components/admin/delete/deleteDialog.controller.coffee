'use strict'

class DeleteDialogCtrl
  constructor: (Slides, $mdMedia, $mdDialog, $q) ->
    this.Slides = Slides
    this.$mdMedia = $mdMedia
    this.$mdDialog = $mdDialog
    this.$q = $q
    this.count = this.images.length
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

    ctrl = this

    #  get first selected images
    this.Slides.get {per: this.cards, ids: this.images}, (r) ->
      ctrl.selectedImages = r.images

  removeAll: ->
    ctrl = this

    promises = []
    this.images.forEach (img, i) ->
      promises.push ctrl.Slides.delete({id: img}).$promise

    this.$q.all(promises).then ->
      ctrl.$mdDialog.hide()

angular.module 'homemademessClient'
.controller 'DeleteDialogCtrl', ['Slides', '$mdMedia', '$mdDialog', '$q', DeleteDialogCtrl]