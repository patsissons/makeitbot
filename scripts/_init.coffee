# Description:
#   first script called, setup event handlers here

module.exports = (robot) ->
  robot.messageRoom 'general', "#{robot.name} service connected"
