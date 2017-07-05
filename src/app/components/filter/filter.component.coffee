'use strict'

class FilterCtrl
  constructor: (filterService, debounce) ->
    this.filterService = filterService
    this.debounce = debounce
    this.selected = false
    this.maxDate = moment().valueOf()
    this.minDate = 0
    this.from = if this.filter?.date?.from? then new Date moment(this.filter.date.from).toISOString() else null
    this.to = if this.filter?.date?.to? then new Date moment(this.filter.date.to).toISOString() else null


  $onInit: () ->
    ctrl = this

    this.selected = this.filter.selected

    this.filterService.getDateBoundaries().then (dates) ->
      #  set min and max
      ctrl.minDate = new Date moment(dates.from).toISOString()
      ctrl.maxDate = new Date moment(dates.to).toISOString()
      #  set
      if ctrl.from is null then ctrl.from = ctrl.minDate
      if ctrl.to is null then ctrl.to = ctrl.maxDate

  $onChanges: () ->
    this.selected = this.filter.selected

  setDate: () ->
    ctrl = this
    if ctrl.from != ctrl.minDate
      from = moment(ctrl.from).valueOf()
      if from != ctrl.filter.date.from
        filter = angular.copy ctrl.filter
        filter.date.from = from
        ctrl.onUpdate {filter: filter}
    if ctrl.to != ctrl.maxDate
      to = moment(ctrl.to).valueOf()
      if to != ctrl.filter.date.to
        filter = angular.copy ctrl.filter
        filter.date.to = to
        ctrl.onUpdate {filter: filter}

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
  controller: ['filterService', 'debounce', FilterCtrl]
