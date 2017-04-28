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

    #  get array of ids for all unselected images in current view
    getSelectedInView: (selected)->
      allEl = angular.element(document).find('md-grid-tile')
      all = []
      ctrl = this
      saveSelectState = (el) ->
        id = angular.element(el).attr 'id'
        if selected and ctrl.selected.indexOf(id) > -1 then all.push id
        if not selected and ctrl.selected.indexOf(id) is -1 then all.push id

      saveSelectState tile for tile in allEl
      all

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