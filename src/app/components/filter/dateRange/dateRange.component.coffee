'use strict'

class DateRangeCtrl
  constructor: (filterService) ->
    this.filterService = filterService
    this.maxDate = moment().valueOf()
    this.minDate = 0
    this.from
    this.to
    this.maxFrom
    this.minTo

  $onInit: () ->
    ctrl = this

    #  set up dates from params
    this.from = if this.filter?.date?.from? and this.filter.date.from != 0 then new Date moment(this.filter.date.from).toISOString() else null
    this.to = if this.filter?.date?.to? and this.filter.date.to != 0 then new Date moment(this.filter.date.to).toISOString() else null
    #  set up specific limits
    this.maxFrom = this.maxDate
    this.minTo = this.minDate
    #  get min and max dates from api
    this.filterService.getDateBoundaries().then (dates) ->
      #  save values in local scope
      ctrl.minDate = new Date moment(dates.from).toISOString()
      ctrl.maxDate = new Date moment(dates.to).toISOString()
      #  if local settings values "from" and "to" are unset, use these values
      if ctrl.from is null then ctrl.from = ctrl.minDate
      if ctrl.to is null then ctrl.to = ctrl.maxDate
      #   now that we have our settings, update the specific limits
      ctrl.maxFrom = ctrl.to
      ctrl.minTo = ctrl.from

  #  when date filter changes come from elsewhere
  $onChanges: () ->
    this.from = if this.filter?.date?.from? and this.filter.date.from != 0 then new Date moment(this.filter.date.from).toISOString() else this.minDate
    this.to = if this.filter?.date?.to? and this.filter.date.to != 0 then new Date moment(this.filter.date.to).toISOString() else this.maxDate

  setDate: () ->
    ctrl = this
    #  FROM
    if ctrl.from != ctrl.minDate
      from = moment(ctrl.from).valueOf()
      if from != ctrl.filter.date.from
        #  update view
        filter = angular.copy ctrl.filter
        filter.date.from = from
        ctrl.onUpdate {filter: filter}
        #  update to's lower limit
        ctrl.minTo = ctrl.from
    #  TO
    if ctrl.to != ctrl.maxDate
      to = moment(ctrl.to).valueOf()
      if to != ctrl.filter.date.to
        #  update view
        filter = angular.copy ctrl.filter
        filter.date.to = to
        ctrl.onUpdate {filter: filter}
        #  update from's upper limit
        ctrl.maxFrom = ctrl.to

angular.module 'homemademessClient'
.component 'dateRange',
  bindings:
    filter: '<'
    onUpdate: '&'
  templateUrl: 'app/components/filter/dateRange/dateRange.html'
  controller: ['filterService', DateRangeCtrl]
