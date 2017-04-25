'use strict'

angular.module 'homemademessClient'
.directive 'slides', ->
  slidesCtrl = [ '$scope', '$state', 'broadcastService', '$mdMedia', 'paramService',
  ($scope, $state, broadcastService, $mdMedia, paramService) ->
    $scope.cols =
      sm: 24
      md: 36
      lg: 48
      gt: 60
    $scope.derivative = 0

    $scope.broadcast = broadcastService

    $scope.getLink = (id) ->
      url = $state.href $state.$current.name + '.slideshow.slide', {slide: id}
      url + paramService.paramsToString()

    ratio = (img) ->
      #  Get aspect ratio as decimal
      Math.round((img.height/img.width)*100)/100

    $scope.aspect = (img,n) ->
      a = ratio img
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

    $scope.clss = (img) ->
      a = ratio img
      clss = if a>1 then "vertical" else if a<1 then "horizontal" else if a==1 then "square"

  ]
  directive =
    restrict: 'E'
    controller: slidesCtrl
    templateUrl: 'app/components/slides/slides.html'
