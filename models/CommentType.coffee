module.exports = (sequelize, DataTypes) ->
  CommentType = sequelize.define 'CommentType',
    value:
      type: DataTypes.STRING
      allowNull: false
      defaultValue: ''

  , classMethods:
    associate: (models) ->
      CommentType.hasMany models.Comment