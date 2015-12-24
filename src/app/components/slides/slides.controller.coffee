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
  slidesCtrl = [ '$scope', '$state', '$rootScope', ($scope, $state, $rootScope) ->
    $scope.curSt = $state.current.name + '.slide'
    $scope.getParams = (n) ->
      {slide: n}
    $scope.getHref = (i) ->
      $state.href '.slide', {slide: i}
    $scope.broadcastLayout = () ->
      $rootScope.$broadcast 'slidesLayout'
    $scope.aspect = (img,n) ->
      #  Get aspect ratio as decimal
      a = Math.round((img.height/img.width)*100)/100
      #  There's a few different cases of how to proceed
      #  if ratio is less than 1 - portrait
      if (a < 1)
        columns = switch
          when a < 0.6 then 8
          when a < 0.4 then 6
          when a < 0.25 then 4
          else 12
        rows = Math.round columns*a
      #  if ratio > 1 - landscape
      else
        rows = switch
          when a > 1.34 then 16
          when a > 2 then 24
          when a > 3 then 36
          else 12
        columns = (Math.round( Math.round(rows*img.width/img.height)/2 ) ) * 2
      aspect = [columns, rows]
      aspect[n]
  ]
  directive =
    restrict: 'E'
    controller: slidesCtrl
    templateUrl: 'app/components/slides/slides.html'
