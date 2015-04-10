`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import absence from 'ember-functional-validation/validators/absence'`

module 'Validators: Absence'

test 'it should exist', (assert) ->
  assert.ok absence
  assert.equal typeof absence, 'function'

test 'it should reject present junk', (assert) ->
  model = 
    email: "foxnewsnetwork@gmail.com"
    username: "foxnewsnetwork"

  absence("email", true, model).then (checkedModel) ->
    assert.ok false, "it should not get here"
  .catch (errors) ->
    assert.equal errors.size, 1
    assert.deepEqual errors.get("email"), ["cannot be present"]

test 'it should resolve absent junk', (assert) ->
  model = null
  absence "email", true, model
  .then (model) ->
    assert.deepEqual model, {}
  .catch (error) ->
    assert.ok false, "it should not reject a good object"

