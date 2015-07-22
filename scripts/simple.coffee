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
#   test - test system (_alias_)
#   hubot tell <user> <message> - pass <user> a message (_alias_)
#
# Notes:
#   Remember to add any commands you create to the commands section above.
#
# Author:
#   pjs

module.exports = (robot) ->
  robot.hear /^test$/i, (msg) -> msg.reply 'Roger, testing...'; msg.send 'All systems nominal!'
  robot.respond /tell (.+) (.+)/i, (msg) -> msg.send "#{msg.match[1]}: #{msg.match[2]}"
