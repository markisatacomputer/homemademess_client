'use strict'

class SlideCtrl
  constructor: ($stateParams, $element, $mdMedia) ->
    this.$stateParams = $stateParams
    this.$mdMedia = $mdMedia
    $element.addClass 'close-slide'

  $onInit: () ->
    ctrl = this

    #  get slide and and set derivative
    index = this.slideshow.view.map.indexOf this.$stateParams.slide
    this.slide = this.slideshow.view.images[index]
    #  get mime type
    this.type = this.slide.mimeType.split('/')[0]
    #  get derivative
    size = this.getDerivative()
    img = this.slide.derivative[size]

    # add layout class
    if (img.height > img.width)
      this.layclss = 'vert'
    else
      this.layclss = 'horz'

    # load image
    this.src = img.uri
    this.label = this.slide.filename

  #  which derivative should we use?
  getDerivative: ->
    switch this.type
      when 'image'
        switch
          when this.$mdMedia 'xs'
            1
          when this.$mdMedia 'sm'
            1
          else
            2
      when 'video'
        1


angular.module 'homemademessClient'
.component 'slide',
  require:
    slideshow: '^^'
  templateUrl: 'app/components/slideshow/slide/slide.html'
  controller: ['$stateParams', '$element', '$mdMedia', SlideCtrl]
