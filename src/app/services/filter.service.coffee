'use strict'

filterService = ($cookies, broadcastService) ->
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

  filterService.display = filterService.getDisplay()
  filterService

angular.module 'homemademessClient'
.factory 'filterService', ['$cookies', 'broadcastService', filterService]