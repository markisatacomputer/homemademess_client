'use strict'

angular.module 'homemademessClient'
.factory 'selectService', ($cookies, broadcastService) ->
  selectService =

    init: ->
      this.selected = this.getSelected()
      this

    getSelected: ->
      selected = $cookies.getObject 'selected'
      if Array.isArray selected
        selected
      else
        []

    emitSelections: ->
      if this.selected.length > 0
        broadcastService.send 'select.has-selected'
        angular.forEach this.selected, (id, i) ->
          broadcastService.send 'select.on', id
      else
        broadcastService.send 'select.empty'

    isEmpty: ->
      if this.selected.length is 0 then true else false

    empty: () ->
      while this.selected.length > 0
        this.toggle this.selected[0]

    toggle: (id) ->
      i = this.selected.indexOf id
      prev = this.isEmpty()
      #  Select
      if i is -1
        this.selected.push id
        broadcastService.send 'select.on', id
      #  Deselect
      else
        this.selected.splice i, 1
        broadcastService.send 'select.off', id

      #  save to cookie
      $cookies.putObject 'selected', this.selected

      #  broadcast when empty status changes
      if this.isEmpty() is not prev
        if prev then broadcastService.send 'select.has-selected' else broadcastService.send 'select.empty'

  selectService.init()
