`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import FunctionalValidation from 'ember-functional-validation'`

module 'Acceptance: FunctionalValidation'

test 'it exists', (assert) ->
  assert.ok FunctionalValidation
  assert.ok FunctionalValidation.create

test 'it should create a validating function', (assert) ->
  validFun = FunctionalValidation.create
    email:
      presence: true
    username:
      presence: true

  assert.ok validFun
  assert.equal typeof validFun, "function"

test 'it should validate objects', (assert) ->
  validFun = FunctionalValidation.create
    email:
      presence: true
    username:
      presence: true
    topic:
      presence: true
      custom: (model) ->
        new Ember.RSVP.Promise (resolve) ->
          Ember.run.later @, (-> resolve "death to juice" ), 10
  
  validFun()
  .then ->
    assert.ok false, "validation should not pass"
  .catch (errors) ->
    assert.ok errors
    assert.equal errors.size, 3
    assert.deepEqual errors.get("email"), ["cannot be blank"]
    assert.deepEqual errors.get("username"), ["cannot be blank"]
    assert.deepEqual errors.get("topic"), ["cannot be blank", "death to juice"]

test 'it should pass objects which are good', (assert) ->
  validFun = FunctionalValidation.create
    email:
      presence: true
    username:
      presence: true
    topic:
      presence: true
      custom: (model) ->
        new Ember.RSVP.Promise (resolve) ->
          Ember.run.later @, resolve, 10
  model =
    email: "foxnewsnetwork@gmail.com"
    username: "foxnewsnetwork"
    topic: "some topic"
  validFun model
  .then (checkedModel) ->
    assert.equal model, checkedModel
  .catch (errors) ->
    assert.ok false, "validation should not fail"

test 'custom validation should have the attribute passed in', (assert) ->
  validFun = FunctionalValidation.create
    email:
      presence: true
      custom: (model, attribute) ->
        assert.equal attribute, "email"
        return null

  model =
    email: "e@mail.co"

  validFun model
  .then (checkedModel) ->
    assert.equal model, checkedModel
  .catch (errors) ->
    assert.ok false, "validation should not fail"