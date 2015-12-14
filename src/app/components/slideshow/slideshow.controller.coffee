'use strict'

angular.module 'homemademessClient'
.directive 'slideshow', ->
  slideshowCtrl = [ '$scope', '$mdDialog', '$stateParams', '$state', '$document',
  ($scope, $mdDialog, $stateParams, $state, $document) ->
    $scope.open = false
    $scope.transition = false

    # add key shortcuts
    $document.bind 'keyup', (e) ->
      if $stateParams.slide and $scope.open and !$scope.transition
        slide = Number $stateParams.slide
        switch e.which
          when 39
            if $scope.slides.length > (slide + 1)
              $state.go $state.current, {slide: slide + 1}
          when 37
            if (slide - 1) > -1
              $state.go $state.current, {slide: slide - 1}
          when 38
            $state.go $state.current, {slide: 0}
          when 40
            $state.go $state.current, {slide: $scope.slides.length - 1}

    # open slide on page load if needed
    $scope.$on 'viewInit', (event, params) ->
      if params.slide
        $scope.updateShowState()

    $scope.updateShowState = () ->
      # open if slide exists and no dialog
      if !$scope.open and $scope.slides[$state.params.slide]
        $scope.open = true
        $scope.showSlide $stateParams.slide

    $scope.showSlide = (i) ->
      i = Number i
      $mdDialog.show
        clickOutsideToClose: true
        locals:
          i: i
          img: $scope.slides[i].derivative[2].uri
          label: $scope.slides[i].filename
        scope: $scope
        preserveScope: true
        onRemoving: () ->
          $scope.open = false
        template: '<md-dialog aria-label="{{label}}" class="slide" ng-class="{loading: transition}">' +
                  '  <md-dialog-content>' +
                  '     <img ng-src="{{img}}" class="img-responsive" ng-class="imgclasses" />' +
                  '     <div class="loading-spinner"></div>' +
                  '  </md-dialog-content>' +
                  '</md-dialog>'
        controller: ($scope, $mdDialog, $stateParams, i, img, label) ->
          $scope.i = i
          $scope.img = img
          $scope.label = label
          $scope.imgclasses = {}

          # listen for location change to update slide
          $scope.$on '$locationChangeStart', (e) ->
            if $stateParams.slide
              $scope.update $stateParams.slide
          # update slide
          $scope.update = (i) ->
            # block further updates while we're waiting
            $scope.transition = true
            # set new url so we can preload
            src = $scope.slides[i].derivative[2].uri
            # on preload complete, finish update
            loader = new Image()
            loader.onload = () ->
              # toggle classes for animation
              $scope.imgclasses = $scope.toggleClass Number i
              # store slide number
              $scope.i = Number i
              # update slide img src
              $scope.img = src
              # update slide img label
              $scope.label = $scope.slides[i].filename
              # unblock slide update
              $scope.transition = false
              # update view
              $scope.$digest()
            # trigger preload
            loader.src = src

          # determine transition direction
          $scope.toggleClass = (i)->
            classes = {
              up: false
              down: false
              left: false
              leftagain: false
              right: false
              rightagain: false
            }
            switch
              when i < $scope.i and (($scope.i - i) > 1) and i is 0
                classes.up = true
              when i > $scope.i and ((i - $scope.i) > 1) and i is ($scope.slides.length - 1)
                classes.down = true
              when i < $scope.i and ($scope.i - i) is 1
                if $scope.imgclasses.left
                  classes.leftagain = true
                else
                  classes.left = true
              when i > $scope.i and ((i - $scope.i) is 1)
                if $scope.imgclasses.right
                  classes.rightagain = true
                else
                  classes.right = true
            classes
                  
      .then null, () ->
        $state.go $state.$current.parent
  ]
  directive =
    restrict: 'E'
    controller: slideshowCtrl
    scope:
      slides: '='
