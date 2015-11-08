# Description:
#   first script called, setup event handlers here

module.exports = (robot) ->
  robot.on 'connected', () -> robot.messageRoom 'general', 'makeitbot connected'
