module.exports = (level, route) ->
  (req, res, next) ->
    if req.params.course_id
      req.course_id = req.params.course_id
    return next() if level is 'public'
    return next() if level is 'teacher' and req.user?.UserTypeId is 2
    return next() if level is 'student' and req.user


    return res.redirect '/'