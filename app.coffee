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

app.use express.static(path.join(__dirname, 'public'))

app.use require('node-sass-middleware')
  src: __dirname
  dest: path.join(__dirname, 'public')
  debug: false
  outputStyle: 'compressed'
  prefix: '/prefix.'

# add styles to all pages
app.use (req, res, next) ->

  models = appRequire('models')
  models.User.find
    where:
      github_id: req.session.passport.user.github_id
    include: models.Course
  .then (user) ->
    app.locals.courses = user.Courses
    app.locals.type = if user.UserTypeId is 2 then 'faculty' else ''
    next()

# setup routes
appRequire('routes') app

# use errors
appRequire('core/errors') app

module.exports = app