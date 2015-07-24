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
#   hubot tell <user> <message> - pass <user> a message
#
# Notes:
#   Remember to add any commands you create to the commands section above.
#
# Author:
#   pjs

module.exports = (robot) ->
  robot.hear /^test$/i, (msg) -> msg.reply 'Roger, testing...'; msg.send 'All systems nominal!'
  robot.respond /tell ([^ ]+) (.+)/i, (msg) -> robot.messageRoom msg.match[1].replace(/^@/, ''), msg.match[2]
  robot.hear /^(who|what|when|where|why) (is|are|was|were) (.+)/i, (msg) -> msg.reply "http://lmgtfy.com/?q=#{encodeURIComponent msg.message.text}"
