'use strict'

class SlideshowCtrl
  constructor: ($state, $document, debounce, $stateParams, swipe, $window) ->
    this.$state = $state
    this.$document = $document
    this.debounce = debounce
    this.stateParams = $stateParams
    this.window = $window
    this.bounce = 400   # debounce in ms

  $onInit: () ->
    ctrl = this

    # body class
    angular.element document.querySelector 'body'
    .addClass 'slideshow'

    # key navigation events
    this.$document
    .off 'keyup'
    .on 'keyup', this.debounce (e) ->
      if !ctrl.$state.transition?
        if [39,37,38,40,27].indexOf e.which != -1
          switch e.which
            when 39 then ctrl.showChange 'slideright'
            when 37 then ctrl.showChange 'slideleft'
            when 38 then ctrl.showChange 'slideup'
            when 40 then ctrl.showChange 'slidedown'
            when 27 then ctrl.showClose()
    , ctrl.bounce, true

    # click out events
    angular.element document.querySelector 'slideshow'
    .off 'click'
    .on 'click', this.debounce (e) ->
      test = angular.element e.target
      .hasClass 'close-slide'
      if test
        ctrl.showClose()
    , ctrl.bounce, true


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
    if this.view.images?
      slideNumber = this.view.map.indexOf this.stateParams.slide
      if slideNumber?
        switch e
          when 'slideright' then n = slideNumber+1
          when 'slideleft'  then n = slideNumber-1
          when 'slideup'    then n = 0
          when 'slidedown'  then n = this.view.images.length-1
      if this.view.images[n]?._id?
        this.window.location.href = this.$state.href(this.$state.current, {slide: this.view.images[n]._id})
    false

  # find parent state and go to there
  showClose: (e)->
    this.window.location.href = this.$state.href('^.^')

angular.module 'homemademessClient'
.component 'slideshow',
  bindings:
    view: '<'
    user: '<'
  templateUrl: 'app/components/slideshow/slideshow.html'
  controller: ['$state', '$document', 'debounce', '$stateParams', 'swipe', '$window', SlideshowCtrl]
