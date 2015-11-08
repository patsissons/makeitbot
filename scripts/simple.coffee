# Description:
#   simple command parsing and responses (such as send/reply)
#
# Dependencies:
#   none
#
# Configuration:
#   none
#
# Commands:
#   test - test system
#   hubot tell <user|room> <message> - send user or room a message from hubot
#
# Notes:
#   Remember to add any commands you create to the commands section above.
#
# Author:
#   pjs

module.exports = (robot) ->
  robot.hear /^test$/i, (msg) -> msg.reply 'Roger, testing...'; msg.send 'All systems nominal!'
  robot.respond /tell ([^ ]+) (.+)/i, (msg) -> robot.messageRoom msg.match[1].replace(/^[#@]/, ''), msg.match[2]
  robot.hear /^(who|what|when|where|why) (is|isn't|does|doesn't|are|aren't|was|wasn't|were|weren't) (.+)/i, (msg) -> msg.reply "http://lmgtfy.com/?q=#{encodeURIComponent msg.message.text}"
