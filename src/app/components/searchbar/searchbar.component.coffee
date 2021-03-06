'use strict'

class SearchbarCtrl
  constructor: ($resource, Auto) ->
    this.Auto = Auto

  #  Autocomplete
  findTags: (value) ->
    return this.Auto.query({q:value,s:0}).$promise

  #  update params and scope on tags update
  updateTags: (tag) ->
    tags = []
    filter = angular.copy this.filter
    # tags to simple array
    angular.forEach this.filter.tag.tags, (t,i) ->
      tags.push t.text
    # send changes upstream
    filter.tag.tagtext = tags
    this.onUpdate {filter: filter}

angular.module 'homemademessClient'
.component 'searchbar',
  controller: ['$resource', 'Auto', SearchbarCtrl]
  bindings:
    filter: '<'
    onUpdate: '&'
  templateUrl: 'app/components/searchbar/searchbar.html'