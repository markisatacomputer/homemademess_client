'use strict'

angular.module 'homemademessClient'
.directive 'menu', ->
  menuCtrl = [ '$scope', 'Auth', '$state', '$mdDialog', 'apiUrl',
  ($scope, Auth, $state, $mdDialog, apiUrl) ->
    $scope.menu =
      admin: [
        {
          label: 'Settings'
          src:   'settings'
          action:  'dialog'
          arg:
            clickOutsideToClose: true
            scope: $scope
            preserveScope: true
            templateUrl: '/app/account/settings/settings.html'
            controller: 'SettingsCtrl'
        }
        {
          label: 'Log Out'
          src:   'exit_to_app'
          action:  'logout'
        }
      ]
      undefined: [
        {
          label: 'Log In'
          src:   'vpn_key'
          action: 'loginDialog'
          arg:  ''
        }
      ]

    $scope.isLoggedIn = Auth.isLoggedIn
    $scope.user =Auth.getCurrentUser()
    $scope.errors = {}
    $scope.menuOpen = false

    $scope.login = (form) ->
      $scope.submitted = true
      if form.$valid
        # Logged in, redirect to home
        Auth.login
          email: $scope.user.email
          password: $scope.user.password
        .then (user) ->
          $mdDialog.hide()
          $scope.menuOpen = true
          $scope.user = user
        .catch (err) ->
          $scope.errors.other = err.message

    $scope.loginOauth = (provider) ->
      $window.location.href = apiUrl + '/auth/' + provider

    $scope.logout = ->
      Auth.logout()
      $scope.user = {}

    $scope.loginDialog = () ->
      $mdDialog.show {
        clickOutsideToClose: true
        scope: $scope
        preserveScope: true
        templateUrl: '/app/account/login/login.html'
        controller: ($scope, $mdDialog) ->
      }

    $scope.go = (there) ->
      $state.go there

    $scope.dialog = (args) ->
      $mdDialog.show args

  ]
  directive =
    restrict: 'E'
    controller: menuCtrl
    templateUrl: 'app/components/menu/menu.html'