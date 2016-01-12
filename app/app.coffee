app = angular.module 'flight-training', ['ngRoute','checklist-model','ui.bootstrap','ngAnimate','textAngular']

app.run ['$rootScope', '$http','$location',($rootScope, $http, $location) ->
  $http.get '/auth'
  .then (userInfo) ->
    $location.path('/') unless userInfo.data
    $rootScope.user = userInfo.data
]

app.filter 'class', () ->
  (mission) ->
    return 'select' unless mission?.MissionStatusId
    missionClass = switch mission.MissionStatusId
      when 1 then 'select'
      when 2 then 'resubmit'
      when 3 then 'pending'
      when 4 then 'complete'
      else 'select'

    return missionClass