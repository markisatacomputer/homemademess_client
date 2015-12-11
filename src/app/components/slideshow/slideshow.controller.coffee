'use strict'

angular.module 'homemademessClient'
.directive 'slideshow', ->
  slideshowCtrl = [ '$scope', '$mdDialog', '$stateParams', '$state', '$document',
  ($scope, $mdDialog, $stateParams, $state, $document) ->
    $scope.open = false

    # add key shortcuts
    $document.bind 'keyup', (e) ->
      if $stateParams.slide and $scope.open
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

    # watch location change and open/close dialog if needed
    $scope.$on '$locationChangeSuccess', (e) ->
      $scope.updateShowState()

    # open slide on page load if needed
    $scope.$watch 'slides', (nw, old) ->
      if nw and !old and !$scope.open
        $scope.updateShowState()

    $scope.updateShowState = () ->
      # open if slide exists and no dialog
      if !$scope.open and $stateParams.slide and $scope.slides[$stateParams.slide]
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
        template: '<md-dialog aria-label="{{label}}" class="slide">' +
                  '  <md-dialog-content>' +
                  '     <img ng-src="{{img}}" class="img-responsive" ng-class="imgclasses" />' +
                  '  </md-dialog-content>' +
                  '</md-dialog>'
        controller: ($scope, $mdDialog, $stateParams, i, img, label) ->
          $scope.i = i
          $scope.img = img
          $scope.label = label
          $scope.imgclasses = {}

          # update slide
          $scope.$on '$locationChangeStart', (e) ->
            if $stateParams.slide
              $scope.update $stateParams.slide
          $scope.update = (i) ->
            $scope.toggleClass Number i
            $scope.i = Number i
            $scope.img = $scope.slides[i].derivative[2].uri
            $scope.label = $scope.slides[i].filename

          # determine transition direction
          $scope.toggleClass = (i)->
            classes =
              up: false
              down: false
              left: false
              right: false
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
            $scope.imgclasses = classes
                  
      .then null, () ->
        $state.go $state.$current.parent
  ]
  directive =
    restrict: 'E'
    controller: slideshowCtrl
    scope:
      slides: '='
