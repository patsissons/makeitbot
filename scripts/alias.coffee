# Description:
#   allows making easy alias commands
#
# Dependencies:
#   none
#
# Configuration:
#   none
#
# Commands:
#   hubot halp _[query]_ - `help` (_alias_)
#   hubot rain - `animate make it rain` (_alias_)
#
# Notes:
#   Remember to add any aliases you create to the commands section above.
#
# Author:
#   pjs

TextMessage = require('hubot').TextMessage

aliasTo = (robot, msg, text) ->
  robot.receive new TextMessage(msg.message.user, "#{robot.name} #{text}")

module.exports = (robot) ->
  robot.respond /halp(.*)/i, (msg) -> aliasTo robot, msg, "help#{msg.match[1]}"
  robot.respond /rain$/i, (msg) -> aliasTo robot, msg, 'animate make it rain'
