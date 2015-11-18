app.controller 'StudentCtrl', ['$rootScope','$scope', '$routeParams','$http', ($rootScope, $scope, $routeParams, $http) ->

  getInfo = () ->
    $http.get '/flights/'+ $routeParams.courseAbbr
    .then (response) ->
      $scope.levels = response.data
  getInfo()

  $scope.getLevelClass = (levels, index) ->
    return 'locked' if levels[index].locked
    if index is 0
      mission = levels[index].StudentMissions[0]
    else
      mission = levels[index-1].StudentMissions[levels[index-1].StudentMissions.length-1]

    $scope.getClass mission

  $scope.getClass = (mission) ->
    return 'select' unless mission?.MissionStatusId
    return 'selected select' if mission.selected
    cssClass = switch mission.MissionStatusId
      when 1
        'submit'
      when 2
        'resubmit'
      when 3
        'pending'
      when 4
        'complete'
      else
        'select'

    cssClass

  $scope.joinFlight = () ->
    $http.post "/flights/#{$routeParams.courseAbbr}/join"
    .then (response) ->
      getInfo()
      user.course.push
        abbr: $routeParams.courseAbbr

  $scope.range = (array, number) ->

    while array.length < number
      array.push {}

    array

  $scope.selectMission = (level, mission, index) ->
    $http.post '/flights/mission',
      StudentLevelId: level.id
      MissionId: mission.id
      MissionStatusId: 1
    .then (response) ->
      level.StudentMissions[index] =
        MissionStatusId: 1
        Mission: mission
        id: response.data.id

  $scope.submitMission = (mission, link) ->
    return unless mission.selected
    data =
      StudentMission:
        id: mission.id,
        MissionStatusId: 3,

      Comment:
        StudentMissionId: mission.id,
        text: link,
        CommentTypeId: 1

    $http.put '/flights/mission', data
    .then (response) ->
      mission.MissionStatusId = 3
      mission.Comments = [] unless mission.Comments
      mission.Comments.push data.Comment
      mission.selected = false

  $scope.submitOwn = (level, mission, index) ->
    data = mission
    data.StudentLevelId = level.id
    data.MissionStatusId = 1
    $http.post '/flights/add/mission', data
    .then (response) ->
      level.StudentMissions[index] =
        MissionStatusId: 1
        Mission: mission
        id: response.data.id




  $scope.deleteMission = (mission_id, index, level) ->
    $http.delete "/flights/mission/#{mission_id}"
    .then () ->
      level.StudentMissions[index] = {}

  $scope.getLocked = (currentLevel, previousLevel) ->
    unless previousLevel
      return false

    if currentLevel.Level.Course.LockTypeId is 1
      return false

    else if currentLevel.Level.Course.LockTypeId is 2
      submitted = 0
      for mission in previousLevel.StudentMissions
        submitted++ if mission.MissionStatusId > 1

      return submitted != previousLevel.to_complete

    else if currentLevel.Level.Course.LockTypeId is 3
      approved = 0
      for mission in previousLevel.StudentMissions
        approved++ if mission.MissionStatusId is 4

      return approved != previousLevel.to_complete

    return false
]