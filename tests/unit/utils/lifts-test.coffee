`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import { errorLift, resolveLift, rejectLift } from 'ember-functional-validation/utils/lifts'`

module "Util: Lifts"

test 'it should all exist', (assert) ->
  assert.ok errorLift
  assert.ok resolveLift
  assert.ok rejectLift

test 'errorLift should always return a map', (assert) ->
  map = errorLift "dog", new Error "are nice"
  assert.ok map.has
  assert.ok map.get
  assert.ok map.set
  assert.ok map.forEach
  assert.ok map.map
  assert.equal map.size, 1
  assert.deepEqual map.get("dog"), ["are nice"]


test 'resolveLift should resolve', (assert) ->
  promise = new Ember.RSVP.Promise (resolve) -> Ember.run.later @, ( -> resolve "nekomimi mode" ), 50
  resolveLift promise
  .then (msg) ->
    assert.equal msg, "nekomimi mode"
  .catch ->
    assert.ok false, "resolve lift should never reject"

test 'resolveLift should coerce a promise to always resolve even if it rejects', (assert) ->
  promise = new Ember.RSVP.Promise (_, reject) -> Ember.run.later @, ( -> reject "nekomimi mode" ), 50
  resolveLift promise
  .then (msg) ->
    assert.equal msg, "nekomimi mode"
  .catch ->
    assert.ok false, "resolve lift should never reject"

test 'it should properly lift pure values to promise', (assert) ->
  value = 8
  resolveLift value
  .then (v) ->
    assert.equal v, value
  .catch ->
    assert.ok false, "resolve lift should never reject"

test 'rejectLift should always reject', (assert) ->
  promise = new Ember.RSVP.Promise (_, reject) -> Ember.run.later @, ( -> reject "nekomimi mode" ), 50
  rejectLift promise
  .then ->
    assert.ok false, "resolve lift should never reject"
  .catch (msg) ->
    assert.equal msg, "nekomimi mode"

test 'rejectLift should coerce a promise to always reject even if it resolves', (assert) ->
  promise = new Ember.RSVP.Promise (resolve) -> Ember.run.later @, ( -> resolve "nekomimi mode" ), 50
  rejectLift promise
  .then ->
    assert.ok false, "resolve lift should never reject"
  .catch (msg) ->
    assert.equal msg, "nekomimi mode"

test 'it should properly lift pure values to rejection', (assert) ->
  value = 7
  rejectLift value
  .then ->
    assert.ok false, "resolve lift should never reject"
  .catch (v) ->
    assert.equal v, value