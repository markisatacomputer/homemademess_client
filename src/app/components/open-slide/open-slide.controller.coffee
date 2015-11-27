'use strict'

angular.module 'homemademessClient'
.directive 'openSlide', [ '$mdDialog', '$location', ($mdDialog, $location) ->
  directive =
    restrict: 'A'
    link: (scope, element, attr) ->
      element.on 'click', (event) ->
        event.preventDefault()
        if window.innerWidth > 459
          # store slides and index
          locals =
            i: Number attr.openSlide
            slides: scope.view.images
          # store location, then update
          location = $location.path()
          $location.path location+'slide/'+locals.i
          # open dialog
          $mdDialog.show {
            clickOutsideToClose: true
            locals: locals
            onRemoving: () ->
              $location.path location
            template: '<md-dialog aria-label="{{label}}" class="slide">' +
                      '  <md-dialog-content keyboard-next keyboard-prev keyboard-start keyboard-end>' +
                      '     <img ng-src="{{img}}" class="img-responsive" />' +
                      '  </md-dialog-content>' +
                      '</md-dialog>'
            controller: ($scope, $mdDialog, $location, i, slides) ->
              $scope.slides = slides
              $scope.i = i
              $scope.img
              $scope.label

              # watch slide index for changes and update slide object
              $scope.$watch 'i', (v, old) ->
                $scope.img = $scope.slides[v].derivative[2].uri
                $scope.label = $scope.slides[v].filename
                $location.path location+'slide/'+v
          }
]
