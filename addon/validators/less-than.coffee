`import Ember from 'ember'`
`import { resolveLift } from '../utils/lifts'`
`import numericalityCore from '../utils/numericality-core'`

errorMsg = """
You must pass in either a function that returns a value, a promise to the value, 
or a value so the validator can properly make comparisons.
"""
lessThan = (attribute, errorCheck, model) ->
  compCore "<", attribute, errorCheck, model

greaterThan = (attribute, errorCheck, model) ->
  compCore ">", attribute, errorCheck, model

equal = (attribute, errorCheck, model) ->
  compCore "=", attribute, errorCheck, model

greaterThanEqualTo = (attribute, errorCheck, model) ->
  compCore ">=", attribute, errorCheck, model

lessThanEqualTo = (attribute, errorCheck, model) ->
  compCore "<=", attribute, errorCheck, model

compCore = (op, attribute, errorCheck, model) ->
  switch
    when typeof errorCheck is "function"
      numericalityCore op, attribute, resolveLift(errorCheck model), model
    when typeof errorCheck is "number"
      numericalityCore op, attribute, resolveLift(errorCheck), model
    when typeof errorCheck?.then is "function"
      numericalityCore op, attribute, errorCheck, model
    else
      throw new Error errorMsg

`export default {
  lessThan,
  greaterThan,
  equal,
  greaterThanEqualTo,
  lessThanEqualTo
}`