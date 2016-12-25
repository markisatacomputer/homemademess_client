'use strict'

angular.module 'homemademessClient'
.factory 'User', ($resource, apiUrl, $cookies) ->
  token = $cookies.get 'token'
  if token
    headers =
      'Authorization' : 'Bearer ' + token

  $resource apiUrl + '/users/:id/:controller',
    id: '@_id'
  ,
    changePassword:
      method: 'PUT'
      params:
        controller: 'password'
      headers: headers

    get:
      method: 'GET'
      params:
        id: 'me'
      headers: headers

