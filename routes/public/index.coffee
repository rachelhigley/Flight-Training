express = require('express')
router  = express.Router()

router.get '/', (req, res, next) ->
  res.render 'index',
    title: 'Flight Training'

router.get '/views/:folder/:file?', (req, res, next) ->
  if req.params.folder && req.params.file
    res.render "#{req.params.folder}/#{req.params.file}"
  else if req.params.folder
    res.render "#{req.params.folder}"


module.exports = router