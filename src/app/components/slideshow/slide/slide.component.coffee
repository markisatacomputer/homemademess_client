'use strict'

class SlideCtrl
  constructor: ($stateParams, $element) ->
    this.$stateParams = $stateParams
    $element.addClass 'close-slide'

  $onInit: () ->
    index = this.slideshow.view.map.indexOf this.$stateParams.slide
    this.slide = this.slideshow.view.images[index]
    img =  this.slide.derivative[2]

    # add layout class
    if (img.height > img.width)
      this.layclss = 'vert'
    else
      this.layclss = 'horz'

    # load image
    this.src = img.uri
    this.label = this.slide.filename

angular.module 'homemademessClient'
.component 'slide',
  require:
    slideshow: '^^'
  templateUrl: 'app/components/slideshow/slide/slide.html'
  controller: SlideCtrl
