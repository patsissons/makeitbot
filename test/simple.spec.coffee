chai = require 'chai'
sinon = require 'sinon'
simple = require '../scripts/simple'

chai.should()
chai.use(require 'sinon-chai')
debugger
describe '#simple script', ->

  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()
    @msg =
      reply: sinon.spy()
      send: sinon.spy()
    @simple = simple @robot
   
  it 'hears test', ->
    @robot.hear.should.have.been.called
    handlers = @robot.hear.getCalls()
      .filter((x) -> x.args[0].test('test'))
      .map((x) -> x.args[1]);
    handlers.should.have.length.of.one;
    handlers[0].call(@robot, @msg);
    @msg.reply.should.have.been.called.once
    @msg.reply.should.have.been.calledWith 'Roger, testing...'
    @msg.send.should.have.been.called.once
    @msg.send.should.have.been.calledWith 'All systems nominal!'
    
  it 'hears testing', ->
    @robot.hear.should.have.been.called
    handlers = @robot.hear.getCalls()
      .filter((x) -> x.args[0].test('testing'))
      .map((x) -> x.args[1]);
    handlers.should.have.length.of.one;
    handlers[0].call(@robot, @msg);
    @msg.reply.should.have.been.called.once
    @msg.send.should.have.been.called.once
    @msg.reply.should.have.been.called.once
    @msg.reply.should.have.been.calledWith 'Roger, testing...'
    @msg.send.should.have.been.called.once
    @msg.send.should.have.been.calledWith 'All systems nominal!'