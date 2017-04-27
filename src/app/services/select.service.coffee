'use strict'

angular.module 'homemademessClient'
.factory 'selectService', ($cookies, broadcastService) ->
  selectService =

    getSelected: ->
      selected = $cookies.getObject 'selected'
      if Array.isArray selected
        selected
      else
        []

    isEmpty: ->
      if this.selected.length is 0 then true else false

    empty: () ->
      while this.selected.length > 0
        this.toggle this.selected[0]

    toggle: (id) ->
      i = this.selected.indexOf id
      prev = this.isEmpty()
      if i is -1
        this.selected.push id
        broadcastService.send 'select.on', id
      else
        this.selected.splice i, 1
        broadcastService.send 'select.off', id

      #  save to cookie
      $cookies.putObject 'selected', this.selected

      #  broadcast when empty status changes
      if this.isEmpty() is not prev
        if prev
          broadcastService.send 'select.has-selected'
        else
          broadcastService.send 'select.empty'

  selectService.selected = selectService.getSelected()
  selectService