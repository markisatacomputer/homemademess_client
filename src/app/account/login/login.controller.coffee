'use strict'

angular.module 'homemademessClient'
.controller 'LoginCtrl', ($scope, Auth, $location, $window, apiUrl) ->
  $scope.errors = {}
  $scope.login = (form) ->
    $scope.submitted = true

    if form.$valid
      # Logged in, redirect to home
      Auth.login
        email: $scope.view.user.email
        password: $scope.view.user.password

      .then (u)->
        console.log u, $scope.view.user

      .catch (err) ->
        $scope.errors.other = err.message

  $scope.loginOauth = (provider) ->
    $window.location.href = apiUrl + '/auth/' + provider
