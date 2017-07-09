'use strict'

class SelectDomCtrl
  constructor: () ->

  $onInit: () ->
    #  add selected class
    angular.element(document.body).addClass 'has-selected'

  $onDestroy: () ->
    # remove selected class
    angular.element(document.body).removeClass 'has-selected'

angular.module 'homemademessClient'
.component 'selectDomControl',
  controller: [SelectDomCtrl]