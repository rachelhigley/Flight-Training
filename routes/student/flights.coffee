express = require('express')
router  = express.Router()
models  = appRequire('models')

router.get '/', (req, res, next) ->
  res.render 'students/welcome'

router.get '/:course_abbr', (req, res, next) ->
  async = require 'async'

  async.parallel
    course: (callback) ->
      models.Course.find
        where:
          abbr: req.params.course_abbr
        include:
          model: models.Level
          include: [models.StudentLevel, {
            model: models.Area
            include: models.Mission
          }]
      .then (course) ->
        callback null, course
    levels: (callback) ->
      models.Level.findAll
        include:
          model: models.StudentMission
          include: [{
              model: models.User
              where:
                id: req.user.id
            },
            {
              model: models.Comment
              include: models.User
            },
            models.Mission
          ]
        order: [['id','ASC'],[models.StudentMission, 'MissionStatusId', 'DESC']]
      .then (levels) ->
        callback null, levels
  , (err, result) ->
    res.render 'students/flight', result

router.get '/:course_abbr/join', (req, res, next) ->
  models.Course.find
    where:
      abbr: req.params.course_abbr
    include: models.Level
  .then (course) ->
    course.addStudent req.user.id
    studentLevels = []
    for level in course.Levels
      studentLevels.push
        LevelId: level.id
        UserId: req.user.id
        to_complete: level.to_complete

    models.StudentLevel.bulkCreate studentLevels
    res.redirect "/flights/#{req.params.course_abbr}"

router.post '/mission', (req, res, next) ->
  req.body.UserId = req.user.id
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

module.exports = router