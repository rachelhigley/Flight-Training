express = require('express')
router  = express.Router()
models  = appRequire('models')

# add the level to the term
router.post '/:id', (req, res, next) ->
  models.Level.update req.body,
    where:
      id: req.params.id
  .then () ->
    res.redirect "/faculty/flights/#{req.course_abbr}/settings"


module.exports = router