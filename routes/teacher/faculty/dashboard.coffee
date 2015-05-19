express = require('express')
router  = express.Router()
models  = appRequire('models')
router.get '/', (req, res, next) ->
  models.User.find req.user.id
  .then (user) ->
    res.render 'faculty/dashboard'

module.exports = router