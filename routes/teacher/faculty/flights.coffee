express = require('express')
router  = express.Router()
models  = appRequire('models')

# list of all the courses for that teacher
router.get '/', (req, res, next) ->
  models.User.find
    where:
      github_id: req.session.passport.user.github_id
    include: [{ all: true, nested: true }]
  .then (user) ->
    res.render 'faculty/flights',
      flights: user.Courses

# create a course with it's levels
router.post '/', (req, res,next) ->
  models.Course.create req.body
  .then (course) ->
    course.addUser req.session.passport.user.id
    models.Level.bulkCreate [{
      CourseId: course.id
      name: 'takeoff'
      to_complete: 0
    },
    {
      CourseId: course.id
      name: 'climb'
      to_complete: 0
    },
    {
      CourseId: course.id
      name: 'cruise'
      to_complete: 0
    },
    {
      CourseId: course.id
      name: 'descent'
      to_complete: 0
    },
    {
      CourseId: course.id
      name: 'landing'
      to_complete: 0
    }
    ]
    res.redirect '/faculty/flights'

# get a course for the teacher
router.get '/:id', (req, res, next) ->
  models.Course.find req.params.id,
    include: [models.Level, models.Term,
      {
        model: models.Area
        include: models.Mission
      }
    ]

    order: [[models.Level, 'id', 'ASC']]
  .then (course) ->
    res.render 'faculty/flight',
      course: course

# save the missions to complete
router.post '/:course_id/level/:id', (req, res, next) ->
  models.Level.update req.body,
    where:
      id: req.params.id
  .then () ->
    res.redirect '/faculty/flights/'+req.params.course_id

# create new terms for the course
router.post '/:course_id/term', (req, res, next) ->
  models.Term.create
    name: req.body.name
    CourseId: req.params.course_id
  .then () ->
    res.redirect '/faculty/flights/'+req.params.course_id

# add the area to the level
router.post '/:course_id/area', (req, res, next) ->
  models.Area.create
    name: req.body.name
    CourseId: req.params.course_id
  .then (area) ->
    for level in req.body['levels[]']
      area.addLevel level

    res.redirect '/faculty/flights/'+req.params.course_id

# add mission to the area
router.post '/:course_id/mission', (req, res, next) ->
  models.Mission.create req.body
  .then () ->
    res.redirect '/faculty/flights/'+req.params.course_id


module.exports = router