'use strict'

angular.module 'homemademessClient'
.directive 'slides', ->
  slidesCtrl = [ '$scope', '$state', '$rootScope', '$mdMedia', ($scope, $state, $rootScope, $mdMedia) ->
    $scope.cols =
      sm: 24
      md: 36
      lg: 48
      gt: 60
    $scope.derivative = 0

    $scope.broadcastLayout = () ->
      $rootScope.$broadcast 'slidesLayout'

    $scope.getLink = (id) ->
      $state.href $state.$current.name + '.slideshow.slide', {slide: id}

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
