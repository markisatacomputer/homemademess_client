'use strict'

angular.module 'homemademessClient'
.directive 'openSlide', [ '$mdDialog', '$location', '$document', '$rootScope', ($mdDialog, $location, $document, $rootScope) ->
  directive =
    restrict: 'A'
    link: (scope, element, attr) ->
      scope.location = $location.path()

      scope.showSlide = (locals) ->
        if !locals.i
          if scope.i then locals.i is scope.i else locals.i is 0
        if !locals.slides
          if scope.view.images then locals.slides is scope.view.images
        $mdDialog.show
          clickOutsideToClose: true
          locals: locals
          preserveScope: true
          onRemoving: () ->
            $location.path scope.location
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
              $location.path scope.location+'slide/'+v
              console.log $scope.img, scope.location+'slide/'+v, $location.path()

      element.on 'click', (event) ->
        if window.innerWidth > 459
          # store slides and index
          locals =
            i: Number attr.openSlide
            slides: scope.view.images
          # open dialog
          scope.showSlide locals
]
