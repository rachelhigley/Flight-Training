passport       = require('passport')
GitHubStrategy = require('passport-github').Strategy
models         = appRequire('models')

passport.serializeUser (user, next) ->
  next null, user

passport.deserializeUser (user, next) ->
  models.User.find
    where:
      github_id: user.github_id
  .then (user) ->
    next null, user

passport.use new GitHubStrategy({
  clientID: process.env.GITHUB_CLIENT
  clientSecret: process.env.GITHUB_SECRET
  callbackURL: process.env.URL+'/auth/github/callback'
}, (accessToken, refreshToken, profile, next) ->
  # update or crete the user in the database
  models.User.findOrCreate
    where:
      github_id: profile.id
    defaults:
      name: profile.displayName
      username: profile.username
      UserTypeId: 1
  .then (user) ->
    next null, user[0]
)