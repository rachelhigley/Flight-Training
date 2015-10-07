app.controller 'FacultyCtrl', ['$rootScope','$scope', '$routeParams','$http', ($rootScope, $scope, $routeParams, $http) ->

  $http.get '/faculty/'+ $routeParams.courseAbbr
  .then (response) ->
    $scope.course = response.data

  $scope.addComment = (mission, newComment) ->
    newComment.CommentTypeId = 2
    newComment.StudentMissionId = mission.id
    $http.post "/faculty/mission/comment", newComment
    .then (response) ->
      response.data.User = $rootScope.user.user
      mission.Comments.push response.data

  $scope.changeStatus = (mission, status) ->
    $http.put "/faculty/mission/status",
      id: mission.id
      MissionStatusId: status
    .then (response) ->
     mission.MissionStatusId = status if response.data[0] is 1

  getTotal = (levels) ->
    total = 0

    for level in levels
      total += level.to_complete

    total

  getCompleted = (missions) ->

    completed = 0

    for mission in missions
      completed++ if mission.MissionStatusId is 4

    completed

  $scope.getPercent = (missions, levels) ->
    return parseInt(getCompleted(missions) / getTotal(levels) * 100)

  $scope.getPending = (missions) ->

    pending = 0

    for mission in missions
      pending++ if mission.MissionStatusId is 3

    pending




]