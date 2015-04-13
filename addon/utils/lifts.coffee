`import Ember from 'ember'`
`import ErrorMap from './error-map'`  

errorLift = (attribute, error) ->
  errorsMap = new ErrorMap()
  if error? and error.message?
    messages = Ember.A [error.message]
  else
    messages = Ember.A [error]
  errorsMap.set attribute, messages
  errorsMap

resolveLift = (maybePromise) ->
  if maybePromise? and maybePromise.then? and typeof maybePromise.then is 'function'
    return Ember.RSVP.allSettled([maybePromise]).then ([result, ...]) ->
      value = if result.state is "fulfilled" then result.value else result.reason
      new Ember.RSVP.Promise (resolve) -> resolve value
  else
    return new Ember.RSVP.Promise (resolve) -> resolve maybePromise

rejectLift = (maybePromise) ->
  if maybePromise? and maybePromise.then? and typeof maybePromise.then is 'function'
    return Ember.RSVP.allSettled([maybePromise]).then ([result, ...]) ->
      value = if result.state is "fulfilled" then result.value else result.reason
      new Ember.RSVP.Promise (_, reject) -> reject value
  else
    return new Ember.RSVP.Promise (_, reject) -> reject maybePromise

`export { resolveLift, rejectLift, errorLift }`
`export default errorLift`