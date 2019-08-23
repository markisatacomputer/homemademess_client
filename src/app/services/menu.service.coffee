'use strict'

menuService = ($state, broadcastService, Auth, lodash) ->
  menuStart:
    [
      {
        label: 'Filter'
        src: 'filter_list'
        action: 'toggleFilters'
        states: ['home']
        roles: ['anon','admin','download']
      }
    ]
  menuMiddle: {}
  menuEnd:
    [
      {
        label: 'Settings'
        src:   'settings'
        action:  'settings'
        states: ['home', 'tagged']
        roles: ['admin']
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
        roles: ['admin']
      }
    ]
  filterMenu: {}
  filterTrigger: {}

  getMenu: (menuname)->
    ctrl = this

    if !menuname?
      #  beggining
      menu = this.menuStart
      #  middle
      angular.forEach this.menuMiddle, (extra, k) ->

        if Array.isArray extra
          menu = menu.concat extra
      #  end
      menu = menu.concat this.menuEnd
    else
      #  other menus
      menu = []
      angular.forEach this[menuname], (menuitem, k) ->
        if Array.isArray menuitem
          menu = menu.concat menuitem

    #  FILTER
    role = this.getUserRole()
    state = this.getState()

    menu = lodash.filter menu, (item) ->
      #  filter roles
      i = lodash.intersection item.roles, role
      #  filter states
      if i.length > 0
        i = lodash.intersection item.states, lodash.words state
      #  extra filters
      if i.length > 0
        lodash.each ctrl.filterMenu, (f, k) ->
          i = f item, i, k
      i.length

  getTrigger: ->
    ctrl = this
    trigger = "menu"
    angular.forEach this.filterTrigger, (f, k) ->
      trigger = f trigger
    trigger

  getUserRole: ->
    user = Auth.getCurrentUser()
    role = if user?.role? then user.role else 'anon'
    if !Array.isArray(role) then role = [role]

  getState: ->
    $state.current.name

  registerMenu: (config) ->
    if config.registerID?
      ctrl = this
      id = config.registerID
      angular.forEach config, (prop, propname) ->
        if propname != 'registerID'
          if typeof ctrl[propname] == 'undefined' then ctrl[propname] = {}
          ctrl[propname][id] = prop
      broadcastService.send 'menu.add', config

  removeMenu: (id) ->
    ctrl = this
    attrs = ['menuExtra', 'filterMenu', 'filterTrigger']
    angular.forEach this, (menu, name) ->
      if ctrl[name][id]?
        delete ctrl[name][id]
    broadcastService.send 'menu.remove', id

angular.module 'homemademessClient'
.factory 'menuService', ['$state', 'broadcastService', 'Auth', 'lodash', menuService]