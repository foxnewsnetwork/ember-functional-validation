`import Ember from 'ember'`
`import buildValidator from './utils/builder'`
`import vid from './validators/id'`
`import reduce from './utils/reduce'`
`import validatorComposition from './utils/compose'`

class FunctionalValidation
  @create = (instructions) ->
    validators = Ember.A()
    for attribute, validations of instructions
      for validatorName, validatorOptions of validations
        validators.pushObject buildValidator 
          attribute: attribute
          validatorName: validatorName
          validatorOptions: validatorOptions

    reduce validators, validatorComposition, vid

`export default FunctionalValidation`    