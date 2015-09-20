`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import FunctionalValidation from 'ember-functional-validation'`

module 'Acceptance: NumericalityValidation',
  beforeEach: ->
    @validFun = FunctionalValidation.create
      username:
        presence: true
      girls:
        lessThan: 3
      docks:
        lessThan: 5
      users:
        lessThan: (x) -> x.get("allowedUsers")
      cats:
        lessThan: new Ember.RSVP.Promise (resolve) -> resolve 5
    ###
    Don't return anything, because QUnit looks for a .then
    that is present on Ember.Application, but is deprecated.
    ###
    return
    


test 'it should have the proper errors', (assert) ->
  account = Ember.Object.create
    username: "Edward II"
    docks: 6
    users: 4
    allowedUsers: 3
    cats: 6

  @validFun account
  .catch (errors) ->
    assert.deepEqual errors.docks, ["must be lessThan 5"]
    assert.deepEqual errors.girls, ["must be lessThan 3"]
    assert.deepEqual errors.users, ["must be lessThan 3"]
    assert.deepEqual errors.cats, ["must be lessThan 5"]

test "it should pass proper objects", (assert) ->
  account = Ember.Object.create
    username: "Edward III"
    docks: 4
    users: 4
    allowedUsers: 6
    cats: 4
    girls: 2

  @validFun account
  .then (a) -> 
    assert.equal a, account