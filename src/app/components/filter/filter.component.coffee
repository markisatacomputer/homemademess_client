'use strict'

class FilterCtrl
  constructor: (filterService, paramService, $scope, $filter) ->
    this.filterService = filterService
    this.paramService = paramService
    this.$scope = $scope
    this.filters = []
    this.showFilters = null
    this.filterActive = 0
    this.selected = false

  $onInit: () ->
    ctrl = this

    this.selected = this.filter.selected

    #  filters start hidden
    this.showFilters = this.filterService.getDisplay()
    #  get active tab
    this.filterActive = this.filterService.getActive()
    #  listen for filter toggle
    this.$scope.$on 'menu.toggleFilters', ->
      ctrl.showFilters = ctrl.filterService.toggleDisplay()

    #  get all filter chips
    this.initFilters()
    #  update filter chipss
    this.$scope.$on 'params:update:push', () ->
      ctrl.initFilters()

  $onChanges: () ->
    #  update selected
    this.selected = this.filter.selected
    #  update when changes come from elsewhere
    this.initFilters()

  updateSelect: ->
    filter = angular.copy this.filter
    filter.selected = this.selected
    this.onUpdate {filter: filter}

  updateActive: ->
    this.filterService.setActive this.filterActive

  initFilters: ->
    ctrl = this
    this.filters = []
    #  get all filters for chips
    angular.forEach this.paramService.getParams(), (v, k) ->
      switch k
        when "tagtext"
          angular.forEach v.split('~~'), (t,i) ->
            ctrl.filters.push {'name': "Tag: " + t, 'key': k, 'value': v}
        when "selected"
          ctrl.filters.push {'name': "Only Selected", 'key': k}
        when "start"
          ctrl.filters.push {'name': "Date >= " + moment(parseInt(v)).format('D.M.YY'), 'key': k}
        when "end"
          ctrl.filters.push {'name': "Date <= " + moment(parseInt(v)).format('D.M.YY'), 'key': k}

  removeFilter: (filter) ->
    updateFilter = angular.copy this.filter
    switch filter.key
      when "tagtext"
        remove = updateFilter.tag.tagtext.indexOf filter.value
        updateFilter.tag.tagtext.splice remove, 1
      when "selected"
        updateFilter.selected = false
      when "start"
        updateFilter.date.from = 0
      when "end"
        updateFilter.date.to = 0
    # send update
    this.onUpdate {filter: updateFilter}

angular.module 'homemademessClient'
.component 'filter',
  bindings:
    filter: '<'
    user: '<'
    onUpdate: '&'
  templateUrl: 'app/components/filter/filter.html'
  controller: ['filterService', 'paramService', '$scope', '$filter', FilterCtrl]
