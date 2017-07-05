angular.module 'homemademessClient'
  .config ($stateProvider, $urlRouterProvider) ->
    'ngInject'

    $stateProvider
      .state 'home',
        url: '/?{tagtext}&{page:int}&{per:int}&{start:int}&{end:int}&{selected}'
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'
        resolve:
          view: (Slides) ->
            Slides.get {},
              (s) ->
                s.data
            .$promise
          user: (Auth) ->
            Auth.getCurrentUser().$promise
          tag: (Tags, $location) ->
            if $location.search().tagtext?
              Tags.get {},
                (t) ->
                  t
              .$promise
            else
              []
        params:
          page:
            dynamic: true
          per:
            dynamic: true
          tagtext:
            dynamic: true
          start:
            dynamic: true
          end:
            dynamic: true
          selected:
            dynamic: true
      .state 'home.slideshow',
        url: 'slide/'
        views:
          'slideshow@home': 'slideshow'
      .state 'home.slideshow.slide',
        url: ':slide/'
        component: 'slide'
      .state 'tagged',
        url: '/tagged/:tag/'
        component: 'taggedDisplay'
        resolve:
          view: (Slides, $transition$) ->
            Slides.get {tagtext: $transition$.params().tag},
              (s) ->
                s.data
            .$promise
          user: (Auth) ->
            Auth.getCurrentUser().$promise
          tag: (Tags, $transition$) ->
            Tags.get {text: $transition$.params().tag},
              (t) ->
                t.data
            .$promise
      .state 'tagged.slideshow',
        url: 'slide/'
        views:
          'slideshow@tagged': 'slideshow'
      .state 'tagged.slideshow.slide',
        url: ':slide/'
        component: 'slide'

    $urlRouterProvider.otherwise '/'
