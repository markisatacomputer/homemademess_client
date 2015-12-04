'use strict'

angular.module 'homemademessClient'
.directive 'keyboard', [ '$document', '$rootScope', ($document, $rootScope) ->
  directive =
    restrict: 'A'
    link: (scope, element, attr) ->
      $document.bind 'keyup', (e) ->
        msg = switch e.which
          when 39 then 'next'
          when 37 then 'prev'
          when 38 then 'start'
          when 40 then 'end'
          else false
        if msg != false
         $rootScope.$broadcast 'keyup:'+ msg, e
]
.directive 'slideshow', ->
  slideshowCtrl = [ '$scope', '$mdDialog', '$location', '$stateParams', '$state', ($scope, $mdDialog, $location, $stateParams, $state) ->
    $scope.open = false

    # watch location change and open/close dialog if needed
    $scope.$on '$locationChangeStart', (e) ->
      $scope.updateShowState()
    
    # update slide on page load
    $scope.$watch 'slides', (nw, old) ->
      if nw and !old
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
          slides: $scope.slides
          img: $scope.slides[i].derivative[2].uri
          label: $scope.slides[i].filename
          location: $state.$current.parent.self.url
        preserveScope: true
        onRemoving: () ->
          $scope.open = false
        template: '<md-dialog aria-label="{{label}}" class="slide">' +
                  '  <md-dialog-content>' +
                  '     <img ng-src="{{img}}" class="img-responsive" />' +
                  '  </md-dialog-content>' +
                  '</md-dialog>'
        controller: ($scope, $mdDialog, $location, $stateParams, i, slides, img, label, location) ->
          $scope.slides = slides
          $scope.i = i
          $scope.img = img
          $scope.label = label
          $scope.location = location

          # update slide
          $scope.update = (i) ->
            if i != $scope.i
              $scope.i = i
              $scope.img = $scope.slides[i].derivative[2].uri
              $scope.label = $scope.slides[i].filename
              $location.path $scope.location+'slide/'+i
              $scope.$apply()
          # next
          $scope.$on 'keyup:next', (e, msg) ->
            if $scope.i < $scope.slides.length - 1
              $scope.update $scope.i+1
          # prev
          $scope.$on 'keyup:prev', (e, msg) ->
            if $scope.i > 0
              $scope.update $scope.i-1
          # first
          $scope.$on 'keyup:start', (e, msg) ->
            if $scope.i != 0
              $scope.update 0
          # last
          $scope.$on 'keyup:end', (e, msg) ->
            if $scope.i != $scope.slides.length - 1
              $scope.update $scope.slides.length - 1
          # location path change - might have to debounce this...
          $scope.$on '$locationChangeStart', (e) ->
            console.log $stateParams.slide, $scope.i, e
  ]
  directive =
    restrict: 'E'
    controller: slideshowCtrl
    scope:
      slides: '='
