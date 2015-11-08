# Description:
#   first script called, setup event handlers here

module.exports = (robot) ->
  robot.on 'error', (error) -> console.log(error)

  robot.messageRoom 'general', "#{robot.name} service connected"
