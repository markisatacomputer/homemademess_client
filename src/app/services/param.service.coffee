'use strict'

angular.module 'homemademessClient'
.factory 'paramService', ($rootScope, $location, broadcastService, $httpParamSerializer) ->
  paramsService =
    #  get params from browser
    getParams: ->
      $location.search()

    #  set browser query params
    updateParams: (params) ->
      angular.forEach params, (param, i) ->
        $location.search i, param
      broadcastService.send 'params:update:push', params

    #  get params from view.filter
    getParamsObject: (filter) ->
      params = {}
      if typeof filter is 'object'
        params.tagtext = if filter.tag.tagtext.length > 0 then this.tagsToParam filter.tag.tagtext else null
        params.page = if filter.pagination.page > 0 then filter.pagination.page else null
        params.per = if filter.pagination.per != 60 then filter.pagination.per else null
      params

    #  Map tags to simple array
    tagsToParam: (tags) ->
      param = ''
      angular.forEach tags, (val, key) ->
        if param.length > 0 then param += '~~'
        param += val.replace /\s/g, '_'
      param

    paramsToString: ->
      str = $httpParamSerializer this.getParams()
      if str.length > 0
        "?" + str

    init: ->
      ctrl = this
      #  watch query params
      $rootScope.$watch () ->
        $location.search()
      , (newSearch, oldSearch) ->
        if !angular.equals newSearch, oldSearch
          broadcastService.send 'params:update:recieve', newSearch
      ctrl

  paramsService.init()

