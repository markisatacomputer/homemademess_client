'use strict'

filterService = ($resource, apiUrl, $cookies, broadcastService) ->
  api =  $resource apiUrl + '/info/:id', {id: @id}

  filterService =
    setDisplay: (set) ->
      if set
        $cookies.put 'showFilter', 1
      else
        $cookies.put 'showFilter', null


    getDisplay: ->
      display = $cookies.get 'showFilter'
      switch display
        when '1' then true
        else false

    toggleDisplay: ->
      display = !this.getDisplay()
      this.setDisplay display
      broadcastService.send 'filterService.toggleDisplay', display
      display

    getDateBoundaries: ->
      api.get {id: 'dates'}, (r) ->
        r
      , (e) ->
        console.log e
      .$promise

  filterService.display = filterService.getDisplay()
  filterService

angular.module 'homemademessClient'
.factory 'filterService', ['$resource', 'apiUrl', '$cookies', 'broadcastService', filterService]