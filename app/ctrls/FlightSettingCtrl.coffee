app.controller 'FlightSettingsCtrl', ['$scope', '$routeParams','$http','$timeout', ($scope, $routeParams, $http, $timeout) ->

  $http.get '/faculty/'+ $routeParams.courseAbbr + '/settings'
  .then (response) ->
    $scope.course = response.data

  $scope.updateMission = (mission) ->
    $http.put '/faculty/mission', mission
    .then (response) ->
      mission.button = 'Updated!'
      $timeout () ->
        mission.button = false
      , 1000

  $scope.deleteMission = (area, index) ->
    $http.delete "/faculty/mission/#{area[index].id}"
    .then () ->
      area.splice index, 1

  $scope.updateLevel = (level) ->
    $http.put "/faculty/level",
      id: level.id
      to_complete: level.to_complete
    .then (data) ->
      console.log data

  $scope.addMission = () ->
    return if $scope.newMission is undefined

    $scope.newMission.courseAbbr = $routeParams.courseAbbr
    $http.post '/faculty/mission', $scope.newMission
    .then (response) ->
      for area,index in $scope.course.Areas
        if area.id is parseInt($scope.newMission.AreaId)
          index = index
          break
      $scope.course.Areas[index].Missions = [] unless $scope.course.Areas[index].Missions
      $scope.course.Areas[index].Missions.push response.data
    # mission POST

  $scope.addArea = () ->
    return if $scope.newArea is undefined
    $scope.newArea.courseAbbr = $routeParams.courseAbbr

    $http.post '/faculty/area', $scope.newArea
    .then (response) ->
      $scope.course.Areas.push response.data
      $scope.newArea = undefined
    # area POST
]