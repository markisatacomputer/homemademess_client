'use strict'

angular.module 'homemademessClient'
.directive 'menu', ->
  menuCtrl = [ '$scope', 'Auth', '$state', '$mdDialog', 'apiUrl',
  ($scope, Auth, $state, $mdDialog, apiUrl) ->
    $scope.menu =
      common: [
        {
          label: 'Home'
          src: 'party_mode'
          action: 'go'
          arg: 'home'
        }
        {
          label: 'Filter'
          src: 'filter_list'
          action: 'go'
          arg: 'home.showFilters'
        }
      ]
      authCommon: [
        {
          label: 'Log Out'
          src:   'exit_to_app'
          action:  'logout'
        }
      ]
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
      ]
      undefined: [
        {
          label: 'Log In'
          src:   'vpn_key'
          action: 'loginDialog'
          arg:  ''
        }
      ]

    $scope.menuOpen = false

    $scope.$watch $scope.view.user, (now, old, equals) ->
      if !equals
        $scope.menuOpen = true
        $scope.$digest()

    $scope.login = (form) ->
      $scope.submitted = true
      if form.$valid
        # Logged in, redirect to home
        Auth.login
          email: $scope.view.user.email
          password: $scope.view.user.password
        .then (user) ->
          $mdDialog.hide()
          $scope.menuOpen = true
          $scope.view.user = user
        .catch (err) ->
          $scope.errors.other = err.message

    $scope.loginOauth = (provider) ->
      $window.location.href = apiUrl + '/auth/' + provider

    $scope.logout = ->
      Auth.logout()
      $scope.view.user = {}

    $scope.loginDialog = () ->
      $mdDialog.show {
        clickOutsideToClose: true
        scope: $scope
        preserveScope: true
        templateUrl: '/app/account/login/login.html'
        controller: ($scope, $mdDialog) ->
      }

    $scope.getMenu = ->
      menu = $scope.menu['common'].concat $scope.menu[$scope.view.user.role]
      if $scope.view.user.role? then menu = menu.concat $scope.menu['authCommon']
      menu

    $scope.go = (there) ->
      $state.go there

    $scope.dialog = (args) ->
      $mdDialog.show args

  ]
  directive =
    restrict: 'E'
    controller: menuCtrl
    templateUrl: 'app/components/menu/menu.html'