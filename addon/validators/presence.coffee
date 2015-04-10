`import Ember from 'ember'`
`import errorLift from '../utils/lifts'`

presence = (attribute, options, model) ->
  model ?= {}
  if Ember.isBlank attribute
    throw new Error "You must specify an attribute for me to validate on your #{model} object"
  message = Ember.getWithDefault options, "message", "cannot be blank"
  new Ember.RSVP.Promise (resolve, reject) ->
    if Ember.isBlank Ember.get model, attribute
      errors = errorLift(attribute, message)
      reject errors
    else
      resolve model

`export default presence`