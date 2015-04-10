`import Ember from 'ember'`
`import errorLift from '../utils/lifts'`

absence = (attribute, options, model) ->
  model ?= {}
  if Ember.isBlank attribute
    throw new Error "You must specify an attribute for me to validate on your #{model} object"
  message = Ember.getWithDefault options, "message", "cannot be present"
  new Ember.RSVP.Promise (resolve, reject) ->
    if Ember.isBlank Ember.get model, attribute
      resolve model
    else
      reject errorLift attribute, message

`export default absence`