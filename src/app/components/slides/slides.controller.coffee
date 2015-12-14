'use strict'

angular.module 'homemademessClient'
.directive 'openSlide', () ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    element.bind "click", ($state, $timeout) ->
      (e) ->
        transition = $timeout(->
          $state.go attrs.state, attrs.params
          return
        )
        e.preventDefault()

        e.preventDefault = ->
        if ignorePreventDefaultCount-- <= 0
          $timeout.cancel transition
        return

.directive 'slides', ->
  slidesCtrl = [ '$scope', '$state', ($scope, $state) ->
    $scope.curSt = $state.current.name + '.slide'
    $scope.getParams = (n) ->
      {slide: n}
    $scope.getHref = (i) ->
      $state.href '.slide', {slide: i}
  ]
  directive =
    restrict: 'E'
    controller: slidesCtrl
    templateUrl: 'app/components/slides/slides.html'
