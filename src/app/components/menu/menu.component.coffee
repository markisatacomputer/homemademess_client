'use strict'

class MenuCtrl
  constructor: (lodash, $state, $scope, Auth, $mdDialog, dropzoneService) ->
    this.lodash = lodash
    this.$state = $state
    this.$scope = $scope
    this.Auth = Auth
    this.$mdDialog = $mdDialog
    this.dropzoneService = dropzoneService
    this.menuOpen = false
    this.menu = []
    this.menuItems =
      [
        {
          label: 'Home'
          src: 'home'
          action: 'home'
          states: ['tagged']
          roles: ['anon','admin','download']
        }
        {
          label: 'Filter'
          src: 'filter_list'
          action: 'showFilters'
          states: ['home']
          roles: ['anon','admin','download']
        }
        {
          label: 'Upload'
          src: 'backup'
          action: 'toggleUpload'
          states: ['home']
          roles: ['admin']
        }
        {
          label: 'Settings'
          src:   'settings'
          action:  'settings'
          states: ['home', 'tagged']
          roles: ['admin','download']
        }
        {
          label: 'Log In'
          src:   'vpn_key'
          action: 'login'
          states: ['home', 'tagged']
          roles: ['anon']
        }
        {
          label: 'Log Out'
          src:   'exit_to_app'
          action:  'logout'
          states: ['home', 'tagged']
          roles: ['admin','download']
        }
      ]

  $onInit: () ->
    ctrl = this

    # init menu
    ctrl.menu = ctrl.getMenu()

    #  watch state and update menu on change
    ctrl.$scope.$watch () ->
      ctrl.$state.current.name
    , (now, old) ->
      if !angular.equals old, now
        ctrl.menu = ctrl.getMenu()

  $onChanges: () ->
    #  wait for user
    if this.user?.$promise?
      ctrl = this
      ctrl.user.$promise.then () ->
        ctrl.menu = ctrl.getMenu()
    else
      this.menu = this.getMenu()

  getMenu: () ->
    ctrl = this
    role = if this.user?.role? then this.user.role else 'anon'
    if !Array.isArray(role) then role = [role]
    ctrl.lodash.filter this.menuItems, (item) ->
      i = ctrl.lodash.intersection item.roles, role
      if i.length > 0
        i = ctrl.lodash.intersection item.states, ctrl.lodash.words ctrl.$state.current.name
        i.length

  #  here's where the action is - ba dum dum
  act: (action) ->
    ctrl = this
    switch action
      when 'showFilters'
        ctrl.onBroadcastAction
          action:
            function: 'toggle'
            arg: 'showFilters'
      when 'toggleUpload'
        this.dropzoneService.toggle()
      when 'login' then ctrl.$mdDialog.show
        clickOutsideToClose: true
        templateUrl: '/app/account/login/login.html'
        controller: 'LoginCtrl'
      when 'logout' then ctrl.Auth.logout()
      when 'home' then ctrl.$state.go 'home'
      when 'settings' then ctrl.$mdDialog.show
        clickOutsideToClose: true
        templateUrl: '/app/account/settings/settings.html'
        controller: 'SettingsCtrl'

angular.module 'homemademessClient'
.component 'menu',
  bindings:
    user: '<'
    onUpdateScope: '&'
    onBroadcastAction: '&'
  templateUrl: 'app/components/menu/menu.html'
  controller: MenuCtrl
