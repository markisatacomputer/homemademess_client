'use strict'

class FilterCtrl
  constructor: (filterService) ->
    this.filterService = filterService
    this.selected = false
    this.maxDate = moment().valueOf()
    this.minDate = 0
    this.maxFrom = this.maxDate
    this.minTo = 0

  $onInit: () ->
    ctrl = this

    this.selected = this.filter.selected

    this.filterService.getDateBoundaries().then (dates) ->
      ctrl.maxDate = dates.to
      ctrl.minDate = dates.from

  $onChanges: () ->
    #console.log this
    this.selected = this.filter.selected

  getMaxFrom: () ->
    if this.filter.date.to? then this.filter.date.to else this.maxDate

  getMinTo: () ->
    if this.filter.date.from? then this.filter.date.from else this.minDate

  updateSelect: () ->
    filter = angular.copy this.filter
    filter.selected = this.selected
    this.onUpdate {filter: filter}

angular.module 'homemademessClient'
.component 'filter',
  bindings:
    filter: '<'
    user: '<'
    onUpdate: '&'
  templateUrl: 'app/components/filter/filter.html'
  controller: ['filterService', FilterCtrl]
