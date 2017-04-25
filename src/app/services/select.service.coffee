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

    toggle: (id) ->
      i = this.selected.indexOf id
      if i is -1
        this.selected.push id
        broadcastService.send 'select.on', id
      else
        this.selected.splice i, 1
        broadcastService.send 'select.off', id

      #  save to cookie
      $cookies.putObject 'selected', this.selected

      #  broadcast if empty
      if this.selected.length is 0
        broadcastService.send 'select.empty', id

  selectService.selected = selectService.getSelected()
  selectService