express = require('express')
router  = express.Router()
models  = appRequire('models')

# add the level to the term
router.put '/', (req, res, next) ->
  models.Level.update req.body,
    where:
      id: req.body.id
  .then (data) ->
    res.send data


module.exports = router