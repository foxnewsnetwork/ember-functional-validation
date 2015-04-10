`import Ember from 'ember'`

Ember.RSVP.on 'error', (reason) -> console.assert false, reason

compose = (vf, vg) ->
  (model) ->
    promiseF = vf model
    promiseG = vg model
    Ember.RSVP.allSettled [promiseF, promiseG]
    .then ([resultF, resultG]) ->
      new Ember.RSVP.Promise (resolve, reject) ->
        if resultF.state is "fulfilled" and resultG.state is "fulfilled"
          resolve model
        else
          reject merge resultF.reason, resultG.reason

merge = (errorsA, errorsB) ->
  return errorsA if Ember.isBlank errorsB
  return errorsB if Ember.isBlank errorsA
  throw new Error "expected an Ember.Map but instead got a #{errorsA}" unless errorsA.has? and errorsA.get?
  throw new Error "expected an Ember.Map but instead got a #{errorsB}" unless errorsB.forEach?
  errorsB.forEach (messages, attributeName) ->
    if errorsA.has attributeName
      messages = errorsA.get(attributeName).concat messages
    errorsA.set attributeName, messages
  errorsA

`export { merge, compose }`
`export default compose`