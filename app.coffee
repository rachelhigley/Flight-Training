require('./app_require')
express        = require('express')
passport       = require('passport')
cookieParser   = require('cookie-parser')
bodyParser     = require('body-parser')
session        = require('express-session')
path           = require('path')
favicon        = require('serve-favicon')
logger         = require('morgan')
sequelizeStore = require('connect-session-sequelize')(session.Store)

appRequire('core/passport-setup')

app            = express()
app.set 'views', path.join(__dirname, 'views')
# view engine setup
app.set 'view engine', 'jade'

app.use express.static(path.join(__dirname, 'public'))

# uncomment after placing your favicon in /public
#app.use(favicon(__dirname + '/public/favicon.ico'));
app.use logger('dev')

app.use cookieParser()
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use session
  secret: 'keyboard cat'
  resave: true
  saveUninitialized: false
  store: new sequelizeStore
    db: appRequire('core/db')

app.use passport.initialize()
app.use passport.session()



app.use require('node-sass-middleware')
  src: __dirname
  dest: path.join(__dirname, 'public')
  debug: false
  outputStyle: 'compressed'
  prefix: '/prefix.'

# setup routes
appRequire('routes') app

# use errors
appRequire('core/errors') app


fs = require 'fs'
coffee = require 'coffee-script'
async = require 'async'

fileData = ""

readDir = (folder, dirRead) ->
  files = fs.readdirSync(folder)
  async.eachSeries files, (file,fileCallback) ->
    # ignore hidden folders
    if file.indexOf('.') is 0
      fileCallback()
    # if it is a file with an ext
    else if file.indexOf('.') > 0
      fs.readFile folder + '/' + file, 'utf8', (err, data) ->
        fileData += "\n#{data}"
        fileCallback()
    #  if it is file
    else
      readDir folder + '/' + file, (data) ->
        fileCallback()
  , (err) ->
    dirRead(err)



readDir __dirname + '/app', (files) ->
  compiled = coffee.compile fileData
  fs.writeFile 'public/js/app.js', compiled, (err) ->

module.exports = app