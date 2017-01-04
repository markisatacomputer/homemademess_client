angular.module 'homemademessClient'
  .config ($stateProvider, $urlRouterProvider) ->
    'ngInject'

    $stateProvider
      .state 'home',
        url: '/?{tags}&{page:int}&{per:int}'
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'
        resolve:
          view: (Slides) ->
            Slides.get {},
              (s) ->
                s.data
          user: (Auth) ->
            Auth.getCurrentUser()
          tgs: (Tags, $location) ->
            if $location.search().tags?
              Tags.get {},
                (t) ->
                  t
            else
              []
        params:
          tags:
            dynamic: true
          page:
            dynamic: true
      .state 'home.slideshow',
        url: 'slide/'
        views:
          'slideshow@home':
            template: '<slideshow slides="view.images" ui-view>'
            controller: ($scope) ->

      .state 'home.slideshow.slide',
        url: ':slide/'
        component: 'slide'
      .state 'tagged',
        url: '/tagged/:tag/'
        templateUrl: 'app/tagged/tagged.html'
        controller: 'TaggedCtrl'
        resolve:
          view: (Slides, $transition$) ->
            Slides.get {tagtext: $transition$.params().tag},
              (s) ->
                s.data
          user: (Auth) ->
            Auth.getCurrentUser()
          tag: (Tags, $transition$) ->
            Tags.get {text: $transition$.params().tag},
              (t) ->
                t.data
      .state 'tagged.slideshow',
        url: 'slide/'
        views:
          'slideshow@tagged':
            template: '<slideshow slides="view.images" ui-view>'
      .state 'tagged.slideshow.slide',
        url: ':slide/'
        component: 'slide'

    $urlRouterProvider.otherwise '/'
