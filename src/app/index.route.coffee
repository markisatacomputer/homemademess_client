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
        resolve:
          slides: ($http, apiUrl, $stateParams) ->
            $http.get apiUrl + '/tagged/' + $stateParams.tag
      .state 'home.tagged.slide',
        url: 'tagged/:tag/slide/:slide'

    $urlRouterProvider.otherwise '/'
