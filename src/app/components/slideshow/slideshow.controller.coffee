'use strict'

angular.module 'homemademessClient'
.controller 'slideshowCtrl', [ '$scope', '$state', '$document', 'slide'
  ($scope, $state, $document, slide) ->
    $scope.slide = $scope.view.map[slide]
    $scope.label = ''
    $scope.imgclass = ''
    $scope.src = ''
    img =  $scope.slide.derivative[2]



    # on preload complete, finish update
    $scope.loading = true
    loader = new Image()
    loader.onload = () ->
      # update slide img src
      $scope.src = img.uri
      # update slide img label
      $scope.label =  $scope.slide.filename
      # unblock slide update
      $scope.loading = false
    loader.onerror = () ->
      $scope.src = img.uri
      $scope.loading = false
    # trigger preload
    loader.src = img.uri

    # add layout class
    setFlex = (img) ->
      if (img.height > img.width)
        clss = 'vert'
      else
        clss = 'horz'
      angular.element document.querySelector 'slide'
      .addClass clss

    setFlex img


    # bind keyboard events to navigation
    showChange = (e)->
      if $scope.view.images?
        switch e.name
          when 'slideright' then n = $scope.slide.n+1
          when 'slideleft'  then n = $scope.slide.n-1
          when 'slideup'    then n = 0
          when 'slidedown'  then n = $scope.view.images.length-1
        if $scope.view.images[n]?._id?
          $scope.imgclass = e.name
          $state.go $state.current, {slide: $scope.view.images[n]._id}
          $scope.slide = $scope.view.images[n]
      false

    # find parent state and go to there
    showClose = (e)->
      $state.go '^'

    # add key shortcuts
    $scope.$on 'slideright', showChange
    $scope.$on 'slideleft', showChange
    $scope.$on 'slideup', showChange
    $scope.$on 'slidedown', showChange
    $scope.$on 'slideout', showClose

  ]
