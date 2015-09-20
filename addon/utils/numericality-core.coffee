`import Ember from 'ember'`
`import { errorLift } from './lifts'`
`import Comparisons from './comparions'`

numericalityCore = (op, attribute, valuePromise, model) ->
  comp = getCompFun op
  value = Ember.get model, attribute
  valuePromise.then (refValue) ->
    new Ember.RSVP.Promise (resolve, reject) ->
      if comp(value, refValue)
        resolve model
      else
        reject errorLift attribute, "must be #{comp.name} #{refValue}"

errorMsg = (op) -> """
`#{op}` is not a known comparison operator. 
The known comparison operators are:

`<`, `>`, `=`, `<=`, and `>=`
"""

getCompFun = (op) ->
  switch op
    when "<" then Comparisons.lessThan
    when ">" then Comparisons.greaterThan
    when "=" then Comparisons.equal
    when "<=" then Comparisons.lessThanEqualTo
    when ">=" then Comparisons.greaterThanEqualTo
    else throw new Error errorMsg(op)

`export default numericalityCore`