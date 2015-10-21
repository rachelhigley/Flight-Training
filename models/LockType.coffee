module.exports = (sequelize, DataTypes) ->
  LockType = sequelize.define 'LockType',
    value:
      type: DataTypes.STRING
      allowNull: false
      defaultValue: ''

  , classMethods:
    associate: (models) ->
      LockType.hasMany models.Course,
        onDelete: 'cascade'