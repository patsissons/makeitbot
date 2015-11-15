# Description:
#   first script called, setup event handlers here

module.exports = (robot) ->
  robot.on 'error', (error) -> console.log(error)

  statusChannel = robot.adapter.client.getChannelGroupOrDMByName "#{robot.name}-status"
  robot.messageRoom "#{statusChannel.name}", "service connected" if statusChannel
