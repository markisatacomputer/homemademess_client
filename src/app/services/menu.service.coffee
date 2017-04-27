'use strict'

angular.module 'homemademessClient'
.factory 'menuService', ($cookies, $state, broadcastService, Auth, lodash) ->
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
  menuEnd:
    [
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
  menuExtra: {}
  filterMenu: {}
  filterTrigger: {}

  getMenu: ->
    ctrl = this

    #  beggining
    menu = this.menuStart
    #  middle
    lodash.forEach this.menuExtra, (extra, k) ->
      if Array.isArray extra
        menu = menu.concat extra
    #  end
    menu = menu.concat this.menuEnd

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
          i = f item, i
      i.length

  getTrigger: ->
    ctrl = this
    trigger = "menu"
    lodash.each this.filterTrigger, (f, k) ->
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
      attrs = ['menuExtra', 'filterMenu', 'filterTrigger']
      id = config.registerID
      lodash.forEach attrs, (name, k) ->
        if config[name]?
          ctrl[name][id] = config[name]
      broadcastService.send 'menu.add', config

  removeMenu: (id) ->
    ctrl = this
    attrs = ['menuExtra', 'filterMenu', 'filterTrigger']
    lodash.forEach attrs, (name, k) ->
      if ctrl[name][id]?
        delete ctrl[name][id]
    broadcastService.send 'menu.remove', id
