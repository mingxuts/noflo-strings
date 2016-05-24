noflo = require 'noflo'

unless noflo.isBrowser()
  chai = require 'chai'
  path = require 'path'
  baseDir = path.resolve __dirname, '..'
else
  baseDir = 'noflo-strings'

describe 'MatchReplace component', ->
  c = null
  match = null
  ins = null
  out = null
  before (done) ->
    loader = new noflo.ComponentLoader baseDir
    loader.load 'strings/MatchReplace', (err, instance) ->
      return done err if err
      c = instance
      match = noflo.internalSocket.createSocket()
      ins = noflo.internalSocket.createSocket()
      out = noflo.internalSocket.createSocket()
      c.inPorts.match.attach match
      c.inPorts.in.attach ins
      c.outPorts.out.attach out
      done()

   describe 'with a given rule', ->
     it 'should provide an array containing potential matches', (done) ->
       expected = [
         'b4'
         'c5'
       ]
       out.on 'data', (data) ->
         chai.expect(data).to.eql expected.shift()
         return if expected.length
         done()
       match.send
         a1: 'a2'
         b3: 'b4'
       ins.send 'b3'
       ins.send 'c5'
       ins.disconnect()
