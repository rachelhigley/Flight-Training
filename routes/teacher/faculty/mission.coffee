express = require('express')
router  = express.Router()
models  = appRequire('models')

# add mission to the area
router.post '/', (req, res, next) ->
  models.Mission.create req.body
  .then (mission) ->
    mission.description = mission.description?.toString('utf8')
    res.send mission

# update mission
router.put '/', (req, res, next) ->
  models.Mission.update req.body,
    where:
      id: req.body.id
  .then (data) ->
    res.send data

# add a comment
router.post '/comment', (req, res, next) ->
  req.body.UserId = req.user.id
  models.Comment.create req.body
  .then (comment) ->
    comment.text = comment.text?.toString('utf8')
    res.send(comment)

# remove mission
router.delete '/:mission_id', (req, res, next) ->
  models.Mission.destroy
    where:
      id: req.params.mission_id
  .then (data) ->
    res.sendStatus 200

# change the mission's status
router.put '/status', (req, res, next) ->
  state = switch req.body.MissionStatusId
    when 2 then 'rejected'
    when 4 then 'accepted'
    else false
  if state
    models.Comment.create
      CommentTypeId: 2
      StudentMissionId: req.body.id
      UserId: req.user.id
      text: " marked your mission as " + state
  models.StudentMission.update req.body,
    where:
      id: req.body.id
  .then (data) ->
    res.send data


module.exports = router