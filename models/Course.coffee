module.exports = (sequelize, DataTypes) ->

  Course = sequelize.define 'Course',
    name:
      type: DataTypes.STRING

    abbr:
      type: DataTypes.STRING

  , classMethods:
    associate: (models) ->
      Course.belongsToMany models.User,
        through: 'Teachers'
        as: 'Teachers'
        onDelete: 'cascade'

      Course.belongsToMany models.User,
        through: models.Student
        as: 'Students'
        onDelete: 'cascade'

      Course.hasMany models.Level,
        onDelete: 'cascade'

      Course.hasMany models.Area,
        onDelete: 'cascade'

      Course.belongsTo models.LockType,
        onDelete: 'cascade'