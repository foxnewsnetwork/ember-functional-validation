`import Ember from 'ember'`
`import { resolveLift, errorLift } from '../utils/lifts'`

custom = (attribute, errorCheck, model) ->
  resolveLift errorCheck model, attribute
  .then (errorMsg) ->
    new Ember.RSVP.Promise (resolve, reject) ->
      if Ember.isBlank errorMsg
        resolve model
      else
        reject errorLift attribute, errorMsg

`export default custom`