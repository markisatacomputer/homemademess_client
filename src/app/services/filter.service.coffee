'use strict'

filterService = ($resource, apiUrl, $cookies, broadcastService) ->
  api =
    $resource apiUrl + '/info/:id',
    {id: @id},
    getArray:
      method: 'GET'
      isArray: true

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

    setActive: (i) ->
      $cookies.put 'activeFilter', i

    getActive: ->
      $cookies.get 'activeFilter'

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

    getUploadDates: ->
      api.getArray {id: 'up'}, (r) ->
        r
      , (e) ->
        console.log e
      .$promise

  filterService.display = filterService.getDisplay()
  filterService

angular.module 'homemademessClient'
.factory 'filterService', ['$resource', 'apiUrl', '$cookies', 'broadcastService', filterService]