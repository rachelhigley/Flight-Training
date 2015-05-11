module.exports = (level) ->
  (req, res, next) ->
    return next() if level is 'public'
    return next() if level is 'teacher' and req.isAuthenticated() and req.session.passport.user.UserTypeId is 2
    return next() if level is 'student' and req.isAuthenticated()


    return res.redirect '/'