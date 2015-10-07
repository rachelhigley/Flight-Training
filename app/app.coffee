app = angular.module 'flight-training', ['ngRoute','checklist-model','ui.bootstrap','ngAnimate','textAngular']

app.run ['$rootScope', '$http','$location',($rootScope, $http, $location) ->
  $http.get '/auth'
  .then (userInfo) ->
    $location.path('/') unless userInfo.data
    $rootScope.user = userInfo.data
]