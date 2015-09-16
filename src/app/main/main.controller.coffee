'use strict'

angular.module 'homemademessClient'
.controller 'MainCtrl', ($scope, $http, apiUrl, $mdDialog, $document) ->
  # init view
  $scope.view = {}
  $scope.slide = {}
  
  $http.get(apiUrl + '/images').success (result) ->
    $scope.view.images = result.images
    $scope.view.tags = result.tags
    $scope.view.offset = 0
  
  $scope.keyup = (e) ->
    if e.keyCode
      i = $scope.slide.$index
      switch e.keyCode
        # Left
        when 37
          if i > 0
            $scope.slide = $scope.view.images[i-1]
            $scope.$apply()
        # Right
        when 39
          if i < $scope.view.images.length - 1
            $scope.slide = $scope.view.images[i+1]
            $scope.$apply()

  $document.on 'keypress', $scope.keyup
  $scope.$on '$destroy', () ->
    $document.off 'keypress', $scope.keyup

  $scope.showSlide = (slide) ->
    console.log window.innerWidth
    if window.innerWidth > 459
      $scope.slide = $scope.view.images[slide]
      $mdDialog.show {
        clickOutsideToClose: true
        scope: $scope
        preserveScope: true
        template: '<md-dialog aria-label="{{slide.filename}}" class="slide">' +
                      '  <md-dialog-content>' +
                      '     <img src="{{slide.derivative[2].uri}}" width="{{vm.slide.derivative[2].width}}" class="img-responsive" />' +
                      '  </md-dialog-content>' +
                      '</md-dialog>'
        controller: ($scope, $mdDialog) ->
          $scope.closeDialog = () ->
            $mdDialog.hide()
      }
