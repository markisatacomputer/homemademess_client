'use strict'

class SlideshowCtrl
  constructor: ($state, $document, debounce, $location, $element) ->
    this.$state = $state
    this.$document = $document
    this.debounce = debounce
    this.location = $location

  $onInit: () ->
    ctrl = this   # for inside debounce functions
    bounce = 400  # debounce in ms

    # body class
    angular.element document.querySelector 'body'
    .addClass 'slideshow'

    # key navigation events
    this.$document
    .off 'keyup'
    .on 'keyup', this.debounce (e) ->
      if !ctrl.$state.transition?
        if [39,37,38,40,27].indexOf e.which != -1
          n = ctrl.uriSlideIdToN ctrl.location.$$path
          if n?
            switch e.which
              when 39 then ctrl.showChange 'slideright', n
              when 37 then ctrl.showChange 'slideleft', n
              when 38 then ctrl.showChange 'slideup', n
              when 40 then ctrl.showChange 'slidedown', n
              when 27 then ctrl.showClose()
    , bounce, true

    # click out events
    angular.element document.querySelector 'slideshow'
    .off 'click'
    .on 'click', this.debounce (e) ->
      test = angular.element e.target
      .hasClass 'close-slide'
      if test
        ctrl.showClose()
    , bounce, false

  $onDestroy: () ->
    angular.element document.querySelector 'body'
    .removeClass 'slideshow'
    # remove click listener
    angular.element document.querySelector 'slideshow'
    .off 'click'
    # unbind keyboard
    this.$document.off 'keyup'

  # slideshow navigation
  showChange: (e, n)->
    if this.slides?
      switch e
        when 'slideright' then nn = n+1
        when 'slideleft'  then nn = n-1
        when 'slideup'    then nn = 0
        when 'slidedown'  then nn = this.slides.length-1
      if this.slides[nn]?._id?
        this.$state.go this.$state.current, {slide: this.slides[nn]._id}
    false

  # find parent state and go to there
  showClose: (e)->
    this.$state.go '^.^'

  uriSlideIdToN: () ->
    match = this.location.$$path.match( /\/slide\/([0-9a-zA-Z]*)\// ).pop()
    if this.map[match]?.n?
      this.map[match].n

angular.module 'homemademessClient'
.component 'slideshow',
  bindings:
    slides: '<'
    map: '<'
  templateUrl: 'app/components/slideshow/slideshow.html'
  controller: SlideshowCtrl
