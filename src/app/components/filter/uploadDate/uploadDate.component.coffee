'use strict'

class UploadDateCtrl
  constructor: (filterService) ->
    this.filterService = filterService
    this.dates = []

  $onInit: () ->
    ctrl = this

    #  get min and max dates from api
    this.filterService.getUploadDates().then (dates) ->
      angular.forEach dates, (timestamp, i) ->
        ctrl.dates.push
          date: moment(timestamp._id).format('MM-DD-YYYY')

  addDate: (date) ->
    filter = angular.copy this.filter
    filter.date.up = date
    this.onUpdate {filter: filter}

angular.module 'homemademessClient'
.component 'uploadDate',
  bindings:
    filter: '<'
    onUpdate: '&'
  templateUrl: 'app/components/filter/uploadDate/uploadDate.html'
  controller: ['filterService', UploadDateCtrl]
