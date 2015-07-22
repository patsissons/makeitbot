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
#   test - `roger, testing...` (_alias_)
#   hubot rain - `animate make it rain` (_alias_)
#
# Notes:
#   Remember to add any aliases you create to the commands section above.
#
# Author:
#   pjs

TextMessage = require('hubot').TextMessage

respondTo = (robot, regex, action) ->
  robot.respond regex, (msg) ->
    action(msg)

hearAbout = (robot, regex, action) ->
  robot.hear regex, (msg) ->
    action(msg)

forwardTo = (robot, msg, text) ->
  robot.receive new TextMessage(msg.message.user, "#{robot.name} #{text}")

module.exports = (robot) ->
  respondTo(robot, /halp(.*)/i, (msg) -> forwardTo(robot, msg, "help#{msg.match[1]}"))
  hearAbout(robot, /^test$/i, (msg) -> msg.reply 'Roger, testing...'; msg.send 'All systems nominal!')
  respondTo(robot, /rain$/i, (msg) -> forwardTo(robot, msg, 'animate make it rain'))
