`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import ErrorMap from 'ember-functional-validation/utils/error-map'`

m = null
module "Util: ErrorMap",
  beforeEach: ->
    m = ErrorMap.create()

test 'it should all exist', (assert) ->
  assert.ok ErrorMap

test 'it should set and get correctly', (assert) ->
  m.set "dog", "rover"
  actual = m.get "dog"
  wanted = "rover"

  assert.equal actual, wanted

test 'it should has property after setting', (assert) ->
  assert.equal m.has("dog"), false
  m.set "dog", "carl"
  assert.equal m.has("dog"), true

test 'it should be possible to have computed properties properly tied', (assert) ->
  Dog = Ember.Object.extend
    name: Ember.computed.alias "errors.name"

  rover = Dog.create errors: m

  assert.ok not rover.get("name")
  m.set "name", "Rover"
  assert.equal m.get("name"), "Rover"
  assert.equal rover.get("name"), "Rover"

test 'for each should iterate properly', (assert) ->
  m.set "name", "James T. Kirk"
  m.set "rank", "Captain"
  m.set "assignment", "USS Enterprise"
  m.set "fucksAliens", true
  actual = []
  m.forEach (value, key) ->
    actual.push [key, value]
  wanted = [
    ["name", "James T. Kirk"],
    ["rank", "Captain"],
    ["assignment", "USS Enterprise"],
    ["fucksAliens", true]
  ]
  assert.deepEqual actual, wanted

test 'it should have a size and length property', (assert) ->
  assert.equal m.length, 0
  m.set "dog", "harold"
  assert.equal m.length, 1
  m.set "dog", "rover"
  assert.equal m.length, 1
  m.set "cat", "fiffy"
  assert.equal m.length, 2