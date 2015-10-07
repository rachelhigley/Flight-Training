express = require('express')
router  = express.Router()
models  = appRequire('models')

router.get '/', (req, res, next) ->
  models.User.find
    where:
      id: req.user.id
    include:
      model: models.Course
      as: 'Students'
      include:
        model: models.Level
        include:
          model: models.StudentLevel
          include: models.StudentMission
  .then (data) ->
    res.send data

router.get '/:course_abbr', (req, res, next) ->
  async = require 'async'

  models.StudentLevel.findAll
    include: [
      model: models.Level
      include: [
        model: models.Area
        include: models.Mission
      ,
        model: models.Course
        where:
          abbr: req.params.course_abbr
      ]
    ,
      model: models.StudentMission
      include: [
        models.Mission
      ,
        model: models.Comment
        include: models.User
      ]
    ]
    order: [[models.Level,'id','ASC'],[models.StudentMission,'MissionStatusId', 'DESC']]

  .then (levels) ->
    for studentLevel in levels
      for mission in studentLevel.StudentMissions
        mission.Mission.description = mission.Mission?.description?.toString('utf8')
        for comment in mission.Comments
          comment.text = comment.text?.toString('utf8')
      for area in studentLevel.Level.Areas
        for mission in area.Missions
          mission.description = mission.description?.toString('utf8')

    res.send levels

router.post '/:course_abbr/join', (req, res, next) ->
  models.Course.find
    where:
      abbr: req.params.course_abbr
    include: models.Level
  .then (course) ->
    course.addStudent req.user.id
    .catch (error) ->
      console.log error
    studentLevels = []
    for level in course.Levels
      studentLevels.push
        LevelId: level.id
        UserId: req.user.id
        to_complete: level.to_complete
        name: level.name

    models.StudentLevel.bulkCreate studentLevels
    res.send 200

router.post '/mission', (req, res, next) ->
  req.body.UserId = req.user.id
  models.StudentMission.create req.body
  .then (data) ->
    res.send
      id: data.id
  .catch (err) ->
    res.sendStatus 200

router.post '/add/mission', (req, res, next) ->
  models.Mission.create req.body
  .then (data) ->
    req.body.UserId = req.user.id
    req.body.MissionId = data.id
    models.StudentMission.create req.body
    .then (data) ->
      res.send
        id: data.id
    .catch (err) ->
      res.sendStatus 200

router.put '/mission', (req, res, next) ->
  req.body.Comment.UserId = req.user.id

  models.StudentMission.update req.body.StudentMission,
    where:
      id: req.body.StudentMission.id
  .then (data) ->
    res.sendStatus 200
  .catch (err) ->
    res.sendStatus 200

  models.Comment.create req.body.Comment
  .catch (err) ->
    console.log err

router.delete '/mission/:id', (req, res, next) ->
  models.StudentMission.destroy
    where:
      id: req.params.id
  .then () ->
    res.sendStatus 200
  .catch (err) ->
    console.log err

module.exports = router