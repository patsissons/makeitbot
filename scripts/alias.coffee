# Description:
#   define new alias commands on the fly
#
#   This script is largely based off the work of the responder script
#   https://github.com/github/hubot-scripts/blob/master/src/scripts/responders.coffee
#   There are a few minor differences, namely that this script does not use
#   eval to process input, and instead simply uses regex replacements.
#   Additionally, this script does not push new listeners and instead manages
#   and matches its list of aliases internally (this simplifies the alias
#   removal process a bit).
#
# Dependencies:
#   none
#
# Configuration:
#   none
#
# Commands:
#   hubot aliases - List all aliases
#   hubot alias /pattern/ [to] alias - Create a new alias
#   hubot alias /pattern/ - Display alias for pattern
#   hubot alias remove /pattern/ - Remove an alias
#
# Notes:
#   Your alias may contain replacement placeholders
#   i.e., hubot alias /something (.+)/ to say something $1 is aliased
#       'hubot something fun' would result in 'hubot say something fun is aliased'
#
#   Every alias can be bound to one or more commands, separate commands with a
#   new line.
#   i.e., hubot alias /spam (.+)/ to
#         say hi $1
#         say how is it going $1
#         say am I annoying yet $1?
#
# Author:
#   pjs

class Aliases
  TextMessage = require('hubot').TextMessage

  constructor: (@robot) ->
    @robot.brain.data.aliases = {}
    @robot.brain.on 'loaded', (data) =>
      for pattern, alias of data.aliases
        @add(pattern, alias.text)

  aliases: ->
    @robot.brain.data.aliases

  alias: (pattern) ->
    @aliases()[pattern]

  remove: (pattern) ->
    alias = @alias(pattern)
    if alias
      delete @aliases()[pattern]
    alias

  add: (pattern, text) ->
    try
      regex = new RegExp("^#{pattern}", 'i')
    catch error
      console.log("Error: #{error}")
      regex = null

    if regex instanceof RegExp
      @remove(pattern)
      @aliases()[pattern] = {
        text: text,
      }
      @alias(pattern)

  respond: (robot, res) ->
    text = res.match[1]

    for pattern, alias of @aliases()
      regex = new RegExp("^#{pattern}", 'i')

      if match = text.match regex
        if match.length > 1
          alias_text = text.replace regex, alias.text
        else
          alias_text = alias.text
        lines = alias_text.trim().split(/\r?\n/)
        for line in lines
          line = line.trim()
          if line
            msg = new TextMessage(res.message.user, "#{robot.name} #{line}")
            # this allows us to avoid responding to our own messages (and infinite loops)
            msg.alias = true
            robot.receive msg

module.exports = (robot) ->
  aliases = new Aliases(robot)

  robot.respond /aliases$/i, (res) ->
    patterns = Object.keys(aliases.aliases()).sort()
    if patterns.length
      result = "#{patterns.length} Defined Aliases:\r\n"
      for pattern, i in patterns
        result += "[#{i}] /#{pattern}/ -> #{aliases.alias(pattern).text}\r\n"
      res.send(result.trim())
    else
      res.send('No Aliases Yet')

  robot.respond /alias \/(.+)\/( to)?([\s\S]+)/i, (res) ->
    pattern = res.match[1]
    text = res.match[3]
    alias = aliases.add(pattern, text)

    if alias
      res.send("Aliasing /#{pattern}/ to #{text}")
    else
      res.send("Error Aliasing /#{pattern}/")

  robot.respond /alias \/(.+)\/$/i, (res) ->
    pattern = res.match[1]
    alias = aliases.alias(pattern)

    if alias
      res.send("Alias for /#{pattern}/ -> #{alias.text}")
    else
      res.send("No Alias for /#{pattern}/")

  robot.respond /alias remove \/(.+)\/$/i, (res) ->
    pattern = res.match[1]
    alias = aliases.remove(pattern)

    if alias
      res.send("Alias for /#{pattern}/ removed")
    else
      res.send("No Alias for /#{pattern}/")

  robot.respond /(.*)/, (res) ->
    if (res.message.alias || false) == false
      aliases.respond(robot, res)
