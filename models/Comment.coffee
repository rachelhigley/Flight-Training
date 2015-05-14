module.exports = (sequelize, DataTypes) ->

  Comment = sequelize.define 'Comment',
    text:
      type: DataTypes.BLOB('long')

  , classMethods:
    associate: (models) ->
      Comment.belongsTo models.CommentType,
        onDelete: 'cascade'
      Comment.belongsTo models.StudentMission,
        onDelete: 'cascade'
      Comment.belongsTo models.User,
        onDelete: 'cascade'