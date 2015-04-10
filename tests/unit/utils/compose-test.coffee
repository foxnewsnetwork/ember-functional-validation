`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import compose from 'ember-functional-validation/utils/compose'`
`import { merge } from 'ember-functional-validation/utils/compose'`
`import presence from 'ember-functional-validation/validators/presence'`
`import curry from 'ember-functional-validation/utils/curry'`

module "Util: compose"

test 'it exist', (assert) ->
  assert.ok compose
  assert.equal typeof compose, 'function'

test 'it should properly merge error maps', (assert) ->
  m1 = new Ember.Map()
  m1.set "dog", Ember.A ["rover"]
  m1.set "cat", Ember.A ["mr. mittens"]
  m2 = new Ember.Map()
  m2.set "dog", Ember.A ["buddy"]
  m2.set "anime", Ember.A ["4losers"]
  actual = merge m1, m2
  
  assert.equal actual.size, 3
  assert.deepEqual actual.get("dog"), Ember.A ["rover", "buddy"]
  assert.deepEqual actual.get("cat"), Ember.A ["mr. mittens"]
  assert.deepEqual actual.get("anime"), Ember.A ["4losers"]

test 'currying should work', (assert) ->
  v1 = curry presence, "email", true
  v1()
  .then ->
    assert.ok false, "it should not resolve a bad object"
  .catch (errors) ->
    assert.equal errors.size, 1
    assert.deepEqual errors.get("email"), ["cannot be blank"]

test 'currying should work successfully', (assert) ->
  v1 = curry presence, "email", true
  v1(email: "dogs@us.gov")
  .then (model) ->
    assert.deepEqual model, email: "dogs@us.gov"
  .catch (errors) ->
    assert.ok false, "it should not reject a good object"

test 'it should properly compose two validators together', (assert) ->
  v1 = curry presence, "email", true
  v2 = curry presence, "password", true
  v3 = compose v1, v2
  assert.ok v3
  assert.equal typeof v3, 'function'
  v3()
  .then ->
    assert.ok false, "it should not have resolved a bad object"
  .catch (errors) ->
    assert.equal errors.size, 2
    assert.deepEqual errors.get("email"), ["cannot be blank"]
    assert.deepEqual errors.get("password"), ["cannot be blank"]

test 'composed validators should pass good data', (assert) ->
  v1 = curry presence, "email", true
  v2 = curry presence, "password", true
  v3 = compose v1, v2
  v3 email: "rover@dog.gov", password: "woofwoof"
  .then (model) ->
    assert.deepEqual model, 
      email: "rover@dog.gov"
      password: "woofwoof"
  .catch (errors) ->
    assert.ok false, "it should not have rejected a good object"

test 'nested composition', (assert) ->
  v1 = curry presence, "email", true
  v2 = curry presence, "password", true
  v3 = compose v1, v2
  v4 = curry presence, "username", true
  v5 = compose v3, v4
  assert.ok v5
  assert.equal typeof v5, 'function'
  v5()
  .then ->
    assert.ok false, "it should not have resolved a bad object"
  .catch (errors) ->
    assert.equal errors.size, 3
    assert.deepEqual errors.get("email"), ["cannot be blank"]
    assert.deepEqual errors.get("password"), ["cannot be blank"]
    assert.deepEqual errors.get("username"), ["cannot be blank"]