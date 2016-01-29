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
  slidesCtrl = [ '$scope', '$state', '$rootScope', '$mdMedia', ($scope, $state, $rootScope, $mdMedia) ->
    $scope.cols =
      sm: 24
      md: 36
      lg: 48
      gt: 60
    $scope.derivative = 0
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
      #  Set columns/rows
      columns = switch
        #  If pano span page width
        when a < 0.4
          switch
            when $mdMedia 'sm'
              $scope.derivative = 0
              $scope.cols.sm
            when $mdMedia 'md'
              $scope.derivative = 0
              $scope.cols.md
            when $mdMedia 'lg'
              $scope.derivative = 1
              $scope.cols.lg
            when $mdMedia 'gt-lg'
              $scope.derivative = 1
              $scope.cols.gt
        #  Default one column
        else
          $scope.derivative = 0
          12
      rows = Math.round columns*a
      aspect = [columns, rows]
      aspect[n]
  ]
  directive =
    restrict: 'E'
    controller: slidesCtrl
    templateUrl: 'app/components/slides/slides.html'
