'use strict'

class SlideInfoCtrl
  constructor: (Slides, $scope, $cookies) ->
    this.Slides = Slides
    this.$scope = $scope
    this.$cookies = $cookies
    this.showSlideInfo = Boolean this.$cookies.get 'showSlideInfo'

  $onInit: () ->
    ctrl = this

    #  get exif
    this.Slides.get { id: this.slide._id}, (slide)->
      ctrl.slide.exif = slide.exif
      ctrl.slide.tags = slide.tags

    #  toggle image info display
    this.$scope.$on 'slide.toggle.info', () ->
      ctrl.toggle()

  toggle: ->
    ctrl = this

    switch this.showSlideInfo
      when true
        ctrl.$cookies.remove 'showSlideInfo'
        ctrl.showSlideInfo = false
      else
        ctrl.$cookies.put 'showSlideInfo', true
        ctrl.showSlideInfo = true

angular.module 'homemademessClient'
.component 'slideInfo',
  bindings:
    slide: '<'
  templateUrl: 'app/components/slideshow/slide/slideInfo.html'
  controller: ['Slides', '$scope', '$cookies', SlideInfoCtrl]
