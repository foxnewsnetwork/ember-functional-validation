`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import custom from 'ember-functional-validation/validators/custom'`

module 'Validators: Custom'

test 'it should exist', (assert) ->
  assert.ok custom
  assert.equal typeof custom, 'function'

test 'it should error out if the checker returns an error msg', (assert) ->
  model = 
    email: "foxnewsnetwork@gmail.com"
    username: "foxnewsnetwork"

  checker = (model) ->
    "bad model is bad"

  custom "email", checker, model
  .then ->
    assert.ok false, "it should not resolve a bad check"
  .catch (errors) ->
    assert.equal errors.size, 1
    assert.deepEqual errors.get("email"), ["bad model is bad"]

test 'it should properly have the attribute passed in', (assert) ->
  model =
    donkey: "animal"

  checker = (model, attribute) ->
    assert.equal attribute, "donkey"
    "animal should be donkey"

  custom "donkey", checker, model
  .catch (errors) ->
    assert.deepEqual errors.get("donkey"), ["animal should be donkey"]

test 'it should resolve promise checkers as well', (assert) ->
  model = 
    email: "foxnewsnetwork@gmail.com"
    username: "foxnewsnetwork"

  checker = (model) ->
    new Ember.RSVP.Promise (resolve) ->
      Ember.run.later @, ( -> resolve "some error message" ), 75

  custom "email", checker, model
  .then ->
    assert.ok false, "it should not resolve a bad check"
  .catch (errors) ->
    assert.equal errors.size, 1
    assert.deepEqual errors.get("email"), ["some error message"]

test 'it should properly handle rejected strings also', (assert) ->
  model = 
    email: "foxnewsnetwork@gmail.com"
    username: "foxnewsnetwork"

  checker = (model) ->
    new Ember.RSVP.Promise (_, reject) ->
      Ember.run.later @, ( -> reject "some error message" ), 75

  custom "email", checker, model
  .then ->
    assert.ok false, "it should not resolve a bad check"
  .catch (errors) ->
    assert.equal errors.size, 1
    assert.deepEqual errors.get("email"), ["some error message"]

test 'it should properly capture errors', (assert) ->
  model = 
    email: "foxnewsnetwork@gmail.com"
    username: "foxnewsnetwork"

  checker = (model) ->
    new Ember.RSVP.Promise ->
      throw new Error "dog food is tasty"

  custom "email", checker, model
  .then ->
    assert.ok false, "it should not resolve a bad check"
  .catch (errors) ->
    assert.equal errors.size, 1
    assert.deepEqual errors.get("email"), ["dog food is tasty"]

test 'things that pass validation should be fine', (assert) ->
  model = 
    email: "foxnewsnetwork@gmail.com"

  checker = (model) -> null
  custom "email", checker, model
  .then (checkedModel) ->
    assert.equal model, checkedModel
  .catch ->
    assert.ok false, "it should not have rejected good models"

test 'things that pass validation should be fine even as a promise', (assert) ->
  model = 
    email: "foxnewsnetwork@gmail.com"

  checker = (model) -> 
    new Ember.RSVP.Promise (resolve) ->
      Ember.run.later @, resolve, 15
  custom "email", checker, model
  .then (checkedModel) ->
    assert.equal model, checkedModel
  .catch ->
    assert.ok false, "it should not have rejected good models"