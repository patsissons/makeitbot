# Description:
#   define new responders on the fly. Each pattern defined can map to any number
#   of responders. When the pattern is matched a random responder will be chosen
#   and emitted.
#
# Dependencies:
#   none
#
# Configuration:
#   none
#
# Commands:
#   hubot respond to /pattern/ [by @sender] with response
#
# Notes:
#   @sender is currently not supported
#
# Author:
#   pjs

class Responses
  constructor: (@robot) ->
    @robot.brain.data.responses = {}

  responses: ->
    @robot.brain.data.responses

  responseList: (pattern) ->
    @responses()[pattern]

  remove: (pattern, index) ->
    responseList = @responseList(pattern)
    if responseList && index
      if index == 'ALL' || responseList.length < 2
        responseList = []
        delete @responses()[pattern]
      else if typeof index == 'number'
        responseList.splice(index, 1)
      else
        responseList = null
    responseList

  add: (pattern, text, sender) ->
    try
      regex = new RegExp("^#{pattern}", 'i')
    catch error
      console.log("Error: #{error}")
      regex = null

    if regex instanceof RegExp
      responseList = @responseList(pattern)
      if !responseList
        responseList = []

      responseList.push {
        text,
        sender
      }
      @responses()[pattern] = responseList
      responseList

  respond: (robot, res) ->
    text = res.match[1]

    for pattern, responseList of @responses()
      regex = new RegExp("#{pattern}", 'i')

      if match = text.match regex
        response = res.random responseList
        if match.length > 1
          response_text = text.replace(regex, response.text)
        else
          response_text = response.text
        lines = response_text.trim().split(/\r?\n/)
        for line in lines
          line = line.trim()
          if line
            res.send line

module.exports = (robot) ->
  responses = new Responses(robot)

  robot.respond /responses$/i, (res) ->
    patterns = Object.keys(responses.responses()).sort()
    if patterns.length
      result = "#{patterns.length} Defined Responses:\r\n"
      for pattern, i in patterns
        responseList = responses.responseList(pattern)
        result += "[#{i}] /#{pattern}/ has #{responseList.length} Options\r\n"
        for response, j in responseList
          result += "[#{i}][#{j}] #{response.text}\r\n"
      res.send(result.trim())
    else
      res.send('No Responses Yet')

  robot.respond /respond to \/(.+)\/ with ([\s\S]+)/i, (res) ->
    pattern = res.match[1]
    text = res.match[2]

    res.message.responder = true
    responseList = responses.add(pattern, text)

    if responseList
      res.send("Responding to /#{pattern}/ with #{text}")
    else
      res.send("Error Responding to /#{pattern}/")

  robot.respond /respond \/(.+)\/$/i, (res) ->
    pattern = res.match[1]

    res.message.responder = true
    responseList = responses.responseList(pattern)

    if responseList
      result = "Response for /#{pattern}/ has #{responseList.length} Options\r\n"
      for response, i in responseList
        result += "[#{i}] #{response.text}\r\n"
      res.send(result.trim())
    else
      res.send("No Responses for /#{pattern}/")

  robot.respond /respond remove \/(.+)\/( (\w+))$/i, (res) ->
    pattern = res.match[1]
    index = res.match[3]

    res.message.responder = true
    responseList = responses.remove(pattern, index)

    if responseList
      if index == 'ALL'
        res.send("All Responses for /#{pattern}/ removed")
      else
        res.send("Response #{index} for /#{pattern}/ removed")
    else
      res.send("No Responses for /#{pattern}/")

  robot.hear /(.*)/, (res) ->
    if res.message.user.name != robot.name && (res.message.responder || false) == false
      responses.respond(robot, res)
