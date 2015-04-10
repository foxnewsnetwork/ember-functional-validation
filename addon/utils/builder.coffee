`import presence from '../validators/presence'`
`import absence from '../validators/absence'`
`import custom from '../validators/custom'`
`import curry from './curry'`

build = (attribute: attribute, validatorName: validatorName, validatorOptions: validatorOptions) ->
  switch validatorName
    when "presence" then (model) -> presence attribute, validatorOptions, model
    when "absence" then (model) -> absence attribute, validatorOptions, model
    when "custom", "inline" then (model) -> custom attribute, validatorOptions, model
    else throw new Error "I don't know what it means to validate the #{attribute} attribute with the #{validatorName} validator"

`export default build`