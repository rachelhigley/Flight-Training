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
      User.belongsTo models.UserType
      User.belongsToMany models.Course,
        through: 'Teachers'
        onDelete: 'cascade'

      User.belongsToMany models.Term,
        through: 'Month'
        onDelete: 'cascade'

      User.belongsToMany models.Mission,
        through: models.StudentMission
        onDelete: 'cascade'