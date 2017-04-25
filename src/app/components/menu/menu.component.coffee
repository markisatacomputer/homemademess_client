'use strict'

class MenuCtrl
  constructor: (lodash, $state, $transitions, $rootScope, broadcastService, selectService) ->
    this.lodash = lodash
    this.$state = $state
    this.state = 'home'
    this.transitions = $transitions
    this.scope = $rootScope
    this.broadcastService = broadcastService
    this.selectService = selectService
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
          label: 'Tag Selected'
          src: 'add_circle'
          action: 'selected.tag'
          states: ['home']
          roles: ['admin']
          select: true
        }
        {
          label: 'Untag Selected'
          src: 'highlight_off'
          action: 'selected.untag'
          states: ['home']
          roles: ['admin']
          select: true
        }
        {
          label: 'Edit Selected'
          src: 'edit'
          action: 'selected.edit'
          states: ['home']
          roles: ['admin']
          select: true
        }
        {
          label: 'Delete Selected'
          src: 'delete'
          action: 'selected.remove'
          states: ['home']
          roles: ['admin']
          select: true
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

    # watch selected changes
    ctrl.scope.$on 'select.has-selected', (e, id) ->
      ctrl.menu = ctrl.getMenu()
    ctrl.scope.$on 'select.empty', (e, id) ->
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
      #  filter roles
      i = ctrl.lodash.intersection item.roles, role
      #  filter states
      if i.length > 0
        i = ctrl.lodash.intersection item.states, ctrl.lodash.words ctrl.state
      #  filter selected
      if i.length > 0
        if ctrl.selectService.isEmpty() and item.select is true
          i.length = 0
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
