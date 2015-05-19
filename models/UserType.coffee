module.exports = (sequelize, DataTypes) ->
  UserType = sequelize.define 'UserType',
    value:
      type: DataTypes.STRING
      allowNull: false
      defaultValue: ''

  , classMethods:
    associate: (models) ->
      UserType.hasMany models.User,
        onDelete: 'cascade'