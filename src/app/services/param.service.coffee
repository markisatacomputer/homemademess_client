'use strict'

paramService = ($rootScope, $location, broadcastService, $httpParamSerializer) ->
  paramsService =
    #  get params from browser
    getParams: ->
      $location.search()

    #  set browser query params
    updateParams: (params) ->
      angular.forEach params, (param, i) ->
        $location.search i, param
      broadcastService.send 'params:update:push', params

    #  get params from view.filter and transform where necessary
    getParamsObject: (filter) ->
      params = {}
      if typeof filter is 'object'
        params.tagtext = if filter.tag.tagtext.length > 0 then this.arrayToParam filter.tag.tagtext, '~~' else null
        params.page = if filter.pagination.page > 0 then filter.pagination.page else null
        params.per = if filter.pagination.per != 60 then filter.pagination.per else null
        params.order = if !angular.equals filter.order, {createDate: "desc"} then this.orderToParam filter.order else null
        params.selected = if filter.selected then filter.selected else null
        params.start = if filter.date.from != 0 then filter.date.from else null
        params.end = if filter.date.to != 0 then filter.date.to else null
        params.up = if filter.date.up then filter.date.up else null
      params

    #  Map tags to simple array
    arrayToParam: (arr, glue) ->
      param = ''
      angular.forEach arr, (val, key) ->
        if param.length > 0 then param += glue
        param += val.replace /\s/g, '_'
      param

    #  Map order object to param string
    orderToParam: (ord) ->
      param = ''
      angular.forEach ord, (val, key) ->
        if param.length > 0 then param += ','
        param += key
        param += switch val
          when 'desc' then '-'
          when 'asc' then '+'
      param

    paramsToString: ->
      str = $httpParamSerializer this.getParams()
      if str.length > 0
        "?" + str
      else
        ""

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

angular.module 'homemademessClient'
.factory 'paramService', ['$rootScope', '$location', 'broadcastService', '$httpParamSerializer', paramService]
