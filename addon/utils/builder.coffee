`import presence from '../validators/presence'`
`import absence from '../validators/absence'`
`import custom from '../validators/custom'`
`import numeric from '../validators/less-than'`
`import curry from './curry'`

build = ({attribute, validatorName, validatorOptions}) ->
  switch validatorName
    when "presence" then (model) -> presence attribute, validatorOptions, model
    when "absence" then (model) -> absence attribute, validatorOptions, model
    when "custom", "inline" then (model) -> custom attribute, validatorOptions, model
    when "lessThan" then (model) -> numeric.lessThan attribute, validatorOptions, model
    when "lessThanEqualTo" then (model) -> numeric.lessThanEqualTo attribute, validatorOptions, model
    when "greaterThan" then (model) -> numeric.greaterThan attribute, validatorOptions, model
    when "greaterThanEqualTo" then (model) -> numeric.greaterThanEqualTo attribute, validatorOptions, model
    when "equal" then numeric.equal attribute, validatorOptions, model
    else throw new Error "I don't know what it means to validate the #{attribute} attribute with the #{validatorName} validator"

`export default build`