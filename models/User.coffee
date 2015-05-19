module.exports = (sequelize, DataTypes) ->

  User = sequelize.define 'User',
    github_id:
      type: DataTypes.INTEGER(11)

    name:
      type: DataTypes.STRING

    username:
      type: DataTypes.STRING

  , classMethods:
    associate: (models) ->
      User.belongsTo models.UserType,
        onDelete: 'cascade'

      User.belongsToMany models.Course,
        through: 'Teachers'
        as: 'Teachers'
        onDelete: 'cascade'

      User.belongsToMany models.Course,
        through: 'Students'
        as: 'Students'
        onDelete: 'cascade'

      User.hasMany models.StudentMission,
        onDelete: 'cascade'

      User.hasMany models.Comment,
        onDelete: 'cascade'

      User.hasMany models.StudentLevel,
        onDelete: 'cascade'
