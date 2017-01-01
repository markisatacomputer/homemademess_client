angular.module 'homemademessClient'
  .config ($stateProvider, $urlRouterProvider) ->
    'ngInject'

    $stateProvider
      .state 'home',
        url: '/?{tags}&{page:int}'
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'
        resolve:
          slides: ($http, apiUrl) ->
            $http.get apiUrl + '/images'
            .then (s)->
              s.data.images
          map: (slides, lodash) ->
            lodash.indexBy slides, '_id'
          user: (Auth) ->
            Auth.getCurrentUser()
          tags: ($location, $http, apiUrl) ->
            tags = $location.search().tags
            if tags != undefined
              $http.get apiUrl + '/tags?text='  + tags
              .then (tags) ->
                tags.data
              , (e) ->
                console.log e
                []
            else
              []
        params:
          tags:
            dynamic: true
          page:
            dynamic: true
      .state 'home.showFilters',
        views:
          'searchbar@home':
            templateUrl: 'app/components/searchbar/searchbar.html'
            controller: 'SearchbarCtrl'
      .state 'home.slideshow',
        url: 'slide/'
        views:
          'slideshow@home':
            template: '<slideshow map="view.map" slides="view.images" ui-view>'
            controller: ($scope) ->

      .state 'home.slideshow.slide',
        url: ':slide/'
        component: 'slide'
      .state 'home.tagged',
        url: 'tagged/:tag/'
        templateUrl: 'app/main/tagged/tagged.html'
        controller: 'TaggedCtrl'
      .state 'home.tagged.slideshow',
        url: 'slide/:slide/'
        templateUrl: 'app/components/slideshow/slideshow.html'
        controller: 'slideshowCtrl'

    $urlRouterProvider.otherwise '/'
