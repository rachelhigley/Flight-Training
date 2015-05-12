express  = require('express')
router   = express.Router()
passport = require('passport')

router.get '/github', passport.authenticate('github'), (req, res) ->
  # The request will be redirected to GitHub for authentication, so this
  # function will not be called.
  return
# GET /auth/github/callback
#   Use passport.authenticate() as route middleware to authenticate the
#   request.  If authentication fails, the user will be redirected back to the
#   login page.  Otherwise, the primary route function function will be called,
#   which, in this example, will redirect the user to the home page.
router.get '/github/callback', passport.authenticate('github', failureRedirect: '/'), (req, res) ->
  if req.user.UserTypeId is 1
    res.redirect '/flights'
  else
    res.redirect '/faculty/dashboard'


router.get '/logout', (req, res, next) ->
  req.logout()
  req.session.destroy () ->
    res.redirect '/'


module.exports = router