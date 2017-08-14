'use strict'

selectService = ($resource, apiUrl, paramService, broadcastService) ->
  api =  $resource apiUrl + '/select/:id',
    {id: @id},
    get:
      method: 'GET'
      isArray: true
    select:
      method: 'POST'
    deselect:
      method: 'DELETE'
    selectAll:
      method: 'POST'
      isArray: true
    deselectAll:
      method: 'DELETE'

  selectService =
    selected: []
    getSelected: ->
      ctrl = this
      api.get (s) ->
        ctrl.selected = s
      , (e) ->
        console.log e
      .$promise

    getSelectedImages: (filter) ->
      ctrl = this
      if filter then filter.returnImages = 1 else filter = {returnImages: 1}
      api.get filter, (s) ->
        s
      , (e) ->
        console.log e
      .$promise

    deleteSelectedImages: ->
      ctrl = this
      api.delete {id: 'images'}, (r) ->
        r
      , (e) ->
        console.log e
      .$promise

    isEmpty: ->
      answer = if this.selected.length is 0 then true else false

    isFull: (count) ->
      answer = if this.selected.length is count then true else false

    none: ->
      ctrl = this

      api.deselectAll paramService.getParams(), (r) ->
        ctrl.selected = []
        broadcastService.send 'select.none'
        broadcastService.send 'menu.reload', false
      , (e) ->
        console.log e
      .$promise

    all: ->
      ctrl = this

      api.selectAll { query: paramService.getParams() }, (s) ->
        ctrl.selected = s
        broadcastService.send 'select.all'
        broadcastService.send 'menu.reload', true
      , (e) ->
        console.log e
      .$promise

    toggle: (id) ->
      ctrl = this
      i = this.selected.indexOf id
      #  Select
      if i is -1
        api.select {id: id}, {}, (s) ->
          if s._id is id
            ctrl.selected.push id
            broadcastService.send 'select.on', id
            broadcastService.send 'menu.reload'
      #  Deselect
      else
        api.deselect {id: id}, (s) ->
          if s._id is id
            ctrl.selected.splice i, 1
            broadcastService.send 'select.off', id
            broadcastService.send 'menu.reload'

  selectService

angular.module 'homemademessClient'
.factory 'selectService', ['$resource', 'apiUrl', 'paramService', 'broadcastService', selectService]
