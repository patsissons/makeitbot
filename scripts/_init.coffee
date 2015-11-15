# Description:
#   first script called, setup event handlers and any other init stuff here

module.exports = (robot) ->
  # log errors to the console
  robot.on 'error', (error) -> console.log(error)

  # get the status channel for this bot (if it exists)
  statusChannel = robot.adapter.client.getChannelGroupOrDMByName "#{robot.name}-status"
  # announce the bot service is connected if we found the channel
  # NOTE: this may result in an error if the bot isn't joined to the channel
  robot.messageRoom "#{statusChannel.name}", "service connected" if statusChannel
