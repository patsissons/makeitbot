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
#   hubot halp - `help` (_alias_)
#   hubot test - `echo roger, testing...` (_alias_)
#   hubot rain - `animate make it rain` (_alias_)
#
# Notes:
#   Remember to add any aliases you create to the commands section above.
#
# Author:
#   pjs

TextMessage = require('hubot').TextMessage

alias = (robot, alias, command) ->
  robot.respond new RegExp(alias, 'i'), (msg) ->
    robot.receive new TextMessage(msg.message.user, "#{robot.name} #{command}")

module.exports = (robot) ->
  alias(robot, 'halp', 'help')
  alias(robot, 'test', 'echo roger, testing...')
  alias(robot, 'rain', 'animate make it rain')
