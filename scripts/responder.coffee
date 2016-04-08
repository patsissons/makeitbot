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
#   hubot respond to /pattern/ [by @sender] with response [in #room]
#   hubot respond remove /pattern/ [index] [in #room]
#   hubot responses [in #room]
#
# Notes:
#
# Author:
#   pjs

class Responses
  constructor: (@robot) ->
    @robot.brain.data.responses = {}
    @robot.brain.data.rooms = {}
    
  getRooms: ->
    @robot.brain.data.roooms
  
  getResponseList: (room, create) ->
    responseList = null
    
    if room
      roomData = @robot.brain.data.rooms[room]
      if roomData
        responseList = roomData.responses
      else if create
        roomData = @robot.brain.data.rooms[room] = { responses: {} }
        responseList = roomData.responses
    else
      responseList = @robot.brain.data.responses
      
    responseList
    
  getPatternResponseList: (pattern, room, create) ->
    patternResponseList = null
    responseList = @getResponseList(room, create)
    
    if responseList
      patternResponseList = responseList[pattern]
      if !patternResponseList && create
        patternResponseList = responseList[pattern] = []
    
    patternResponseList
    
  getResponse: (text, room) ->
    response = null
    
    for pattern, patternResponseList of @getResponseList(room)
      regex = new RegExp("#{pattern}", 'i')

      if match = text.match regex
        responseItem = res.random patternResponseList
        
        if match.length > 1
          response = text.replace(regex, response.text)
        else
          response = response.text
        
        break
    
    response
  
  remove: (pattern, index, room) ->
    responses = @getPatternResponses(pattern, room)
    
    if responses
      if typeof index == 'number'
        responses.splice(index, 1)
      else
        responses = null
    
      if !responses || responses.length == 0
        delete @getResponses(room)[pattern]

  add: (pattern, text, sender, room) ->
    try
      regex = new RegExp("^#{pattern}", 'i')
    catch error
      console.log("Error: #{error}")
      regex = null

    if regex instanceof RegExp
      responses = @getPatternResponses(pattern, room, true)

      responses.push {
        text,
        sender
      }
    #   @getResponses(room)[pattern] = responses
      responses

  respond: (robot, res) ->
    text = res.match[1]
    room = res.envelope.room
    
    response = @getResponse(text, room)
    
    if !response
      response = @getResponse(text)
      
    if response
      lines = response_text.trim().split(/\r?\n/)
      for line in lines
        line = line.trim()
        if line
            res.send line

module.exports = (robot) ->
  responses = new Responses(robot)
  
  getPatternResponses: (pattern, patternResponseList) ->
    patternResponse = { 
      pattern, 
      text: "/#{pattern}/ has #{patternResponseList.length} Responses", 
      responses: [] 
    }
    
    for response, i in patternResponseList
      patternResponse.responses.push "[#{i}] #{response.text}"
      
    patternResponse
  
  getResponses: (responseList) ->
    responses = []
    patterns = Object.keys(responses.responses()).sort()
    
    for pattern in patterns
      patternResponseList = responseList[pattern]
      
      responses.push @getPatternResponses(pattern, patternResponseList)
    
    responses

  robot.respond /responses$/i, (res) ->
    responses = []
    globalResponses = @getResponses(@responses.getResponseList())
    
    if globalResponses.length
      responses.push {
        room: null,
        responses: globalResponses
      }
    
    rooms = Object.keys(@responses.getRooms()).sort()
    for room in rooms
      roomResponses = @getResponses(@responses.getResponseList(room))
      responses.push {
        room,
        responses: roomResponses
      }
      
    text = []
    for roomResponse in responses
      text.push "#{roomResponse.responses.length} #{roomResponse.room ? '#' : ''}#{roomResponse.room ? roomResponse.room : 'global'} Responses"
      for patternResponse in roomResponse.responses
        text.push "  #{patternResponse.text}"
        for response in patternResponse.responses
          text.push "    #{response}"
    
    if text.length
      res.send(text.join(', ').trim())
    else
      res.send('No Responses Yet')

  robot.respond /respond to \/(.+)\/ with ([\s\S]+)/i, (res) ->
    pattern = res.match[1]
    text = res.match[2]

    res.message.responder = true
    responses = @responses.add(pattern, text)

    if responses
      res.send("Responding to /#{pattern}/ with #{text}")
    else
      res.send("Error Responding to /#{pattern}/")

  robot.respond /respond \/(.+)\/$/i, (res) ->
    pattern = res.match[1]

    res.message.responder = true
    patternResponseList = @responses.getPatternResponses(pattern)
    patternResponses = @getPatternResponses(pattern, patternResponseList)

    if patternResponses.responses.length
      text = [patternResponses.text]
      for response in patternResponses.responses
        text.push "  #{response}"
      res.send(text.join(', ').trim())
    else
      res.send("No Responses for /#{pattern}/")

  robot.respond /respond remove \/(.+)\/( (\w+))$/i, (res) ->
    pattern = res.match[1]
    index = res.match[3]

    res.message.responder = true
    responses = responses.remove(pattern, index)

    if responses
      if index
        res.send("Response #{index} for /#{pattern}/ removed")
      else
        res.send("All Responses for /#{pattern}/ removed")
    else
      res.send("No Responses for /#{pattern}/")

  robot.hear /(.*)/, (res) ->
    if res.message.user.name != robot.name && (res.message.responder || false) == false
      responses.respond(robot, res)
