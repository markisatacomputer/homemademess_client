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
  
  $scope.keydown = (e) ->
    console.log e
    if e.keyCode
      i = $scope.slide.$index
      switch e.keyCode
        # Left
        when 37
          if i > 0
            $scope.slide = $scope.view.images[i-1]
        # Right
        when 39
          if i < $scope.view.images.length - 1
            $scope.slide = $scope.view.images[i+1]
        # Page Up
        when 33
          if i != 0
            $scope.slide = $scope.view.images[0]
        # Page Down
        when 34
          if i != $scope.view.images.length - 1
            $scope.slide = $scope.view.images[$scope.view.images.length - 1]
      $scope.$apply()

  $scope.showSlide = (slide) ->
    if window.innerWidth > 459
      $scope.slide = $scope.view.images[slide]
      $mdDialog.show {
        clickOutsideToClose: true
        scope: $scope
        preserveScope: true
        template: '<md-dialog aria-label="{{slide.filename}}" class="slide">' +
                      '  <md-dialog-content>' +
                      '     <img src="{{slide.derivative[2].uri}}" class="img-responsive" />' +
                      '  </md-dialog-content>' +
                      '</md-dialog>'
        controller: ($scope, $mdDialog, $document) ->
          $document.on 'keydown', $scope.keydown
          $scope.lastpress = 0
          $scope.closeDialog = () ->
            $mdDialog.hide()
            $document.off 'keypress', $scope.keyup
      }
