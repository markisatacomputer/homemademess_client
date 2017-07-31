angular.module 'homemademessClient'
  .config ($logProvider) ->
    'ngInject'
    #  Enable log
    $logProvider.debugEnabled true
  .config ($cookiesProvider) ->
    'ngInject'
    #  Set Cookie defaults
    $cookiesProvider.defaults.domain = Location.host
