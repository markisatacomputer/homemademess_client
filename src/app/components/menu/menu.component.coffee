'use strict'

class MenuCtrl
  constructor: (lodash, $state, $transitions, broadcastService) ->
    this.lodash = lodash
    this.$state = $state
    this.state = 'home'
    this.transitions = $transitions
    this.broadcastService = broadcastService
    this.menuOpen = false
    this.menu = []
    this.menuItems =
      [
        {
          label: 'Home'
          src: 'home'
          href: this.$state.href 'home'
          states: ['tagged']
          roles: ['anon','admin','download']
        }
        {
          label: 'Filter'
          src: 'filter_list'
          action: 'toggleFilters'
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
          label: 'Edit Mode'
          src: 'edit'
          action: 'toggleEdit'
          states: ['home','tagged']
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
          action: 'toggleAuth'
          states: ['home', 'tagged']
          roles: ['anon']
        }
        {
          label: 'Log Out'
          src:   'exit_to_app'
          action:  'toggleAuth'
          states: ['home', 'tagged']
          roles: ['admin','download']
        }
      ]

  $onInit: () ->
    ctrl = this

    # init state
    this.state = this.$state.current.name

    # init menu
    ctrl.menu = ctrl.getMenu()

    # watch state changes and update menu
    ctrl.transitions.onFinish {}, (trans) ->
      if (ctrl.state != trans._targetState._definition.name)
        ctrl.state = trans._targetState._definition.name
        ctrl.menu = ctrl.getMenu()

  $onChanges: (changes) ->
    #  wait for user
    if this.user?.$promise?
      ctrl = this
      ctrl.user.$promise.then () ->
        ctrl.menu = ctrl.getMenu()
    else
      this.menu = this.getMenu()

  getMenu: () ->
    ctrl = this
    role = if ctrl.user?.role? then ctrl.user.role else 'anon'
    if !Array.isArray(role) then role = [role]
    ctrl.lodash.filter ctrl.menuItems, (item) ->
      i = ctrl.lodash.intersection item.roles, role
      if i.length > 0
        i = ctrl.lodash.intersection item.states, ctrl.lodash.words ctrl.state
        i.length

  #  here's where the action is - ba dum dum
  act: (action) ->
    this.broadcastService.send 'menu.' + action

angular.module 'homemademessClient'
.component 'menu',
  bindings:
    user: '<'
  templateUrl: 'app/components/menu/menu.html'
  controller: MenuCtrl
