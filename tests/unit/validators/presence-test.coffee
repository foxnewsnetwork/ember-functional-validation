`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import presence from 'ember-functional-validation/validators/presence'`

module 'Validators: Presence'

test 'it should exist', (assert) ->
  assert.ok presence
  assert.equal typeof presence, 'function'

test 'it should resolve to a good promise on a good object', (assert) ->
  model = 
    email: "foxnewsnetwork@gmail.com"
    username: "foxnewsnetwork"

  presence("email", true, model).then (checkedModel) ->
    assert.equal checkedModel, model
  .catch ->
    assert.ok false, "it should not get here"

test 'it should properly reject a bad object', (assert) ->
  model = null
  presence "email", true, model
  .then ->
    assert.ok false, "it should not resolve a bad object"
  .catch (error) ->
    assert.equal error.size, 1
    assert.equal error.get("email"), "cannot be blank"

test 'it should properly error when missing an attribute', (assert) ->
  assert.throws presence, /must specify an attribute/

test 'it should be able to display a custom message', (assert) ->
  presence "email", { message: ">tfw no gf" }, null
  .then ->
    assert.ok false, "it should not resolve a bad object"
  .catch (error) ->
    assert.equal error.size, 1
    assert.equal error.get("email"), ">tfw no gf"