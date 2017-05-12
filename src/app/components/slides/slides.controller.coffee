'use strict'

class SlidesCtrl
  constructor: ($scope, $state, broadcastService, $mdMedia) ->
    this.$scope = $scope
    this.$state = $state
    this.broadcastService = broadcastService
    this.$mdMedia = $mdMedia
    this.cols =
      sm: 24
      md: 36
      lg: 48
      gt: 60
    this.derivative = 0

  getLink: (id) ->
    this.$state.href this.$state.$current.name + '.slideshow.slide', {slide: id}

  ratio: (img) ->
    #  Get aspect ratio as decimal
    Math.round((img.height/img.width)*100)/100

  aspect: (img,n) ->
    a = this.ratio img
    #  Set columns/rows
    columns = switch
      #  If pano span page width
      when a < 0.4
        switch
          when $mdMedia 'sm'
            this.derivative = 0
            this.cols.sm
          when $mdMedia 'md'
            this.derivative = 0
            this.cols.md
          when $mdMedia 'lg'
            this.derivative = 1
            this.cols.lg
          when $mdMedia 'gt-lg'
            this.derivative = 1
            this.cols.gt
      #  Default one column
      else
        this.derivative = 0
        12
    rows = Math.round columns*a
    aspect = [columns, rows]
    aspect[n]

  clss: (img) ->
    a = this.ratio img
    clss = if a>1 then "vertical" else if a<1 then "horizontal" else if a==1 then "square"

angular.module 'homemademessClient'
.component 'slides',
  bindings:
    view: '<'
    user: '<'
  templateUrl: 'app/components/slides/slides.html'
  controller: SlidesCtrl
