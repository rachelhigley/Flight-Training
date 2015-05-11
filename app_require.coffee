path = require('path')
module.exports = do ->

  global.appRequire = (name) ->
    require path.join(__dirname, name)

  return