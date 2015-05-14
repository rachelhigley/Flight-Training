express = require('express')
router  = express.Router()
models  = appRequire('models')

router.get '/', (req, res, next) ->
  res.render 'students/welcome'

router.get '/:course_id', (req, res, next) ->
  async = require 'async'

  async.parallel
    course: (callback) ->
      models.Course.find
        where:
          id: req.params.course_id
        include:
          model: models.Level
          include: [ {
            model: models.Area
            include:[models.Mission]
            }
          ]

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

router.post '/mission', (req, res, next) ->
  req.body.UserId = req.user.id
  models.StudentMission.create req.body
  .then (data) ->
    res.send
      id: data.id
  .catch (err) ->
    res.sendStatus 200

router.put '/mission', (req, res, next) ->
  console.log req.body
  req.body.StudentMission.UserId = req.body.Comment.UserId = req.user.id

  models.StudentMission.update req.body.StudentMission,
    where:
      id: req.body.StudentMission.id
      UserId: req.user.id
  .then (data) ->
    res.sendStatus 200
  .catch (err) ->
    res.sendStatus 200

  models.Comment.create req.body.Comment
  .catch (err) ->
    console.log err

module.exports = router