'use strict'

class SlideshowCtrl
  constructor: ($state, $document, debounce, $stateParams, paramService, $window) ->
    this.$state = $state
    this.$document = $document
    this.debounce = debounce
    this.stateParams = $stateParams
    this.paramService = paramService
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
          slideNumber = ctrl.view.map.indexOf ctrl.stateParams.slide
          if slideNumber?
            switch e.which
              when 39 then ctrl.showChange 'slideright', slideNumber
              when 37 then ctrl.showChange 'slideleft', slideNumber
              when 38 then ctrl.showChange 'slideup', slideNumber
              when 40 then ctrl.showChange 'slidedown', slideNumber
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
      switch e
        when 'slideright' then nn = n+1
        when 'slideleft'  then nn = n-1
        when 'slideup'    then nn = 0
        when 'slidedown'  then nn = this.view.images.length-1
      if this.view.images[nn]?._id?
        this.window.location.href = this.$state.href(this.$state.current, {slide: this.view.images[nn]._id})
    false

  # find parent state and go to there
  showClose: (e)->
    this.window.location.href = this.$state.href('^.^')

angular.module 'homemademessClient'
.component 'slideshow',
  bindings:
    view: '<'
  templateUrl: 'app/components/slideshow/slideshow.html'
  controller: ['$state', '$document', 'debounce', '$stateParams', 'paramService', '$window', SlideshowCtrl]
