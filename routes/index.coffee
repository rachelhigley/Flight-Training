fs       = require('fs')
restrict = appRequire('core/restrict')

loadFile = (files, dir, level, app) ->

  files.forEach (file) ->
    if file.indexOf('.') isnt -1
      name = file.split('.')[0]
      route = dir.replace(level+'/', '')
      restricted = restrict level, route
      include = './' + dir + '/' +name
      url = '/'+ route + if name is 'index' then '' else name
      app.use url, restricted , require include
    else
      next_level = dir + file + '/'
      files = fs.readdirSync __dirname + '/' + next_level
      loadFile files, next_level, level, app

module.exports = (app) ->
  fs.readdirSync __dirname
  .filter (file) ->
    file.indexOf('.') != 0 and file != 'index.coffee'
  .forEach (folder) ->
    dir = folder
    files = fs.readdirSync __dirname + '/' + dir
    loadFile files, dir + '/', folder, app