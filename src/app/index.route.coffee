angular.module 'homemademessClient'
  .config ($stateProvider, $urlRouterProvider) ->
    'ngInject'
    $stateProvider
      .state 'home',
        url: '/'
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'
        resolve:
          slides: ($http, apiUrl) ->
            $http.get apiUrl + '/images'
      .state 'home.slide',
        url: 'slide/:slide'
      .state 'home.tagged',
        url: 'tagged/:tag/'
        templateUrl: 'app/main/tagged/tagged.html'
        controller: 'TaggedCtrl'
      .state 'home.tagged.slide',
        url: 'slide/:slide'

    $urlRouterProvider.otherwise '/'
