express = require('express')
router  = express.Router()
models  = appRequire('models')
router.get '/', (req, res, next) ->
  models.User.find
    where:
      github_id: req.session.passport.user.github_id
    include: [{ all: true, nested: true }]
  .then (user) ->
    res.render 'index'

module.exports = router