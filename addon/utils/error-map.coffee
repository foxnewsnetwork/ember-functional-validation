`import Ember from 'ember'`

ErrorMap = Ember.Object.extend
  init: ->
    @_super arguments...
    @core = {}
    @length = 0
    @size = 0

  set: (key, value) ->
    unless @has key
      @incrementProperty "length"
      @incrementProperty "size"
    @core[key] = value
    @_super arguments...

  has: (key) ->
    @core.hasOwnProperty key

  forEach: (cb) ->
    @map cb
  
  map: (cb) ->
    output = Ember.A()
    for key, value of @core
      output.push cb value, key
    output

`export default ErrorMap`