'use strict'

class MenuActionCtrl
  constructor: (Auth, $mdDialog, $state) ->
    this.Auth = Auth
    this.$mdDialog = $mdDialog
    this.$state = $state

  # react to menu action
  $onChanges: (changes) ->
    #  if this action is included in the scope object and changes have been made to scope as a result of our action - don't start a loop
    if this.scope[this.action]? and changes.scope?
      return false

    ctrl = this
    switch this.action
      when 'showFilters' then ctrl.onUpdate { name: 'showFilters', value: !ctrl.scope.showFilters }
      when 'login' then ctrl.$mdDialog.show
        clickOutsideToClose: true
        templateUrl: '/app/account/login/login.html'
        controller: 'LoginCtrl'
        onComplete: (scope, el) ->
          ctrl.onUpdate { name: 'user', value: scope.user }
      when 'logout'
        ctrl.Auth.logout()
        ctrl.onUpdate {name: 'user', value: {} }
      when 'home' then ctrl.$state.go 'home'
      when 'settings' then ctrl.$mdDialog.show
        clickOutsideToClose: true
        templateUrl: '/app/account/settings/settings.html'
        controller: 'SettingsCtrl'

angular.module 'homemademessClient'
.component 'menuAction',
  bindings:
    action: '<'
    scope: '<'
    onUpdate: '&'
  controller: MenuActionCtrl