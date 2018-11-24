'use strict'

class SlidesCtrl
  constructor: ($scope, $state, broadcastService, $mdMedia, selectService) ->
    this.$scope = $scope
    this.$state = $state
    this.broadcastService = broadcastService
    this.$mdMedia = $mdMedia
    this.selectService = selectService
    this.cols =
      xs: 12
      sm: 24
      md: 36
      lg: 48
      gt: 60
    this.derivative = 0

  getLink: (id) ->
    this.$state.href this.$state.$current.name + '.slideshow.slide', {slide: id}

  ratio: (img) ->
    #  Get aspect ratio as decimal
    if img.mimeType.search('video') >= 0
      Math.round((img.derivative[0].height/img.derivative[0].width)*100)/100
    else
      Math.round((img.height/img.width)*100)/100

  aspect: (img,n) ->
    ctrl = this
    a = this.ratio img
    #  Set columns/rows
    columns = switch
      #  If pano span page width
      when a < 0.4
        switch
          when ctrl.$mdMedia 'xs'
            ctrl.derivative = 0
            ctrl.cols.xs
          when ctrl.$mdMedia 'sm'
            ctrl.derivative = 0
            ctrl.cols.sm
          when ctrl.$mdMedia 'md'
            ctrl.derivative = 0
            ctrl.cols.md
          when ctrl.$mdMedia 'lg'
            ctrl.derivative = 1
            ctrl.cols.lg
          when ctrl.$mdMedia 'gt-lg'
            ctrl.derivative = 1
            ctrl.cols.gt
      #  tall pics
      when a > 1.8
        ctrl.derivative = 0
        cols = (1/a)*12
        Math.ceil(cols/3)*3
      #  Default one column
      else
        ctrl.derivative = 0
        12
    rows = Math.round columns*a
    aspect = [columns, rows]
    aspect[n]

  # prevent slideshow if slides are selected
  tryLink: (e, img) ->
    if !this.selectService.isEmpty()
      e.preventDefault()
      this.selectService.toggle img._id


angular.module 'homemademessClient'
.component 'slides',
  bindings:
    view: '<'
    user: '<'
  templateUrl: 'app/components/slides/slides.html'
  controller: ['$scope', '$state', 'broadcastService', '$mdMedia', 'selectService', SlidesCtrl]
