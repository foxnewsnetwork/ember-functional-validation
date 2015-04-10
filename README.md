# Ember-Functional-Validation

An functional approach to object validations for emberjs.

This is just like Dockyard's ember validation library, except instead it builds a bunch of functions instead of being a bunch of object mixins that are advertised to work on all Ember.Objects, but actually only work on things with the container.

# HowTo
Suppose you have a comment model
Declare your validating function somewhere

```coffee
# app/validators/comment
import FunctionalValidation from 'ember-functional-validation'

commentValidator = FunctionalValidation.create
  postName:
    presence: true
  opEmail:
    format: /\w+@\w+\.com/
    length:
      min: 5
  content:
    presence: true
export default commentValidator
```

Then, because commentValidator is just a function, use it wherever you please.
```coffee
# app/controller/posts/new
import commentValidator from 'app/validators/comment'
PostsNewController = Ember.Controller.extend
  actions
    newComment: (comment) ->
      commentValidator comment
      .then (validComment) ->
        validComment.save()
        ...
      .catch (errors) ->
        @displayErrors errors
```
Note that the commentValidator always returns a promise

Because of the functional nature of your validator, you can compose them: (admittedly, although this feature is useful for building this library, I can't really think of an use-case for it in a real application)
```coffee
import californianValidator from '../validators/californian'
import droughtVictimValidator from '../validators/drought-victim'
import compose from 'ember-functional-validation/utils/compose'

socalValidator = compose californianValidator, droughtVictomValidator
resident = store.createRecord "socalResident",
  lowPayingJob: true
  noWater: true
  traffic: true
  atLeastNotSF: true

socalValidator resident
.then (validResident) ->
  validResident.save()
  ...
.catch (errors) ->
  # do stuff with errors
```
## Validators ##

The below is lifted almost bodily from dockyard's validation library:

https://raw.githubusercontent.com/dockyard/ember-validations/master/README.md

The sections not yet implemented are noted. (This *is* beta software, after all, and I'm writing this only because I actually need it, not because I'm trying to sell it to others)

### Absence ###
Validates the property has a value that is `null`, `undefined`, or `''`

#### Options ####
  * `true` - Passing just `true` will activate validation and use default message
  * `message` - Any string you wish to be the error message. Overrides `i18n`.

```javascript
// Examples
absence: true
absence: { message: 'must be blank' }
```

### Acceptance ###
*not implemented yet*
By default the values `'1'`, `1`, and `true` are the acceptable values

#### Options ####
  * `true` - Passing just `true` will activate validation and use default message
  * `message` - Any string you wish to be the error message. Overrides `i18n`.
  * `accept` - the value for acceptance

```javascript
// Examples
acceptance: true
acceptance: { message: 'you must accept', accept: 'yes' }
```

### Confirmation ###
*not implemented yet*
Expects a `propertyConfirmation` to have the same value as
`property`. The validation must be applied to the `property`, not the `propertyConfirmation` (otherwise it would expect a `propertyConfirmationConfirmation`).

#### Options ####
  * `true` - Passing just `true` will activate validation and use default message
  * `message` - Any string you wish to be the error message. Overrides `i18n`.

```javascript
// Examples
confirmation: true
confirmation: { message: 'you must confirm' }
```

### Exclusion ###
*not implemented yet*
A list of values that are not allowed

#### Options ####
  * `message` - Any string you wish to be the error message. Overrides `i18n`.
  * `allowBlank` - If `true` skips validation if value is empty
  * `in` - An array of values that are excluded
  * `range` - an array with the first element as the lower bound the and second element as the upper bound. Any value that falls within the range will be considered excluded

```javascript
// Examples
exclusion: { in: ['Yellow', 'Black', 'Red'] }
exclusion: { range: [5, 10], allowBlank: true, message: 'cannot be between 5 and 10' }
```

### Format ###
*not implemented yet*
A regular expression to test with the value

#### Options ####
  * `message` - Any string you wish to be the error message. Overrides `i18n`.
  * `allowBlank` - If `true` skips validation if value is empty
  * `with` - The regular expression to test with

```javascript
// Examples
format: { with: /^([a-zA-Z]|\d)+$/, allowBlank: true, message: 'must be letters and numbers only'  }
```

### Inclusion ###
*not implemented yet*
A list of the only values allowed

#### Options ####
  * `message` - Any string you wish to be the error message. Overrides `i18n`.
  * `allowBlank` - If `true` skips validation if value is empty
  * `in` - An array of values that are allowed
  * `range` - an array with the first element as the lower bound the and
second element as the upper bound. Only values that fall within the range will be considered allowed

```javascript
// Examples
inclusion: { in: ['Yellow', 'Black', 'Red'] }
inclusion: { range: [5, 10], allowBlank: true, message: 'must be between 5 and 10' }
```

### Length ###
*not implemented yet*
Define the lengths that are allowed

#### Options ####
  * `number` - Alias for `is`
  * `array` - Will expand to `minimum` and `maximum`. First element is the lower bound, second element is the upper bound.
  * `allowBlank` - If `true` skips validation if value is empty
  * `minimum` - The minimum length of the value allowed
  * `maximum` - The maximum length of the value allowed
  * `is` - The exact length of the value allowed
  * `tokenizer` - A function that should return a object that responds to `length`

##### Messages #####
  * `tooShort` - the message used when the `minimum` validation fails. Overrides `i18n`
  * `tooLong` - the message used when the `maximum` validation fails. Overrides `i18n`
  * `wrongLength` - the message used when the `is` validation fails. Overrides `i18n`

```javascript
// Examples
length: 5
length: [3, 5]
length: { is: 10, allowBlank: true }
length: { minimum: 3, maximum: 5, messages: { tooShort: 'should be more than 3 characters', tooLong: 'should be less than 5 characters' } }
length: { is: 5, tokenizer: function(value) { return value.split(''); } }
```

### Numericality ###
*not implemented yet*
Will ensure the value is a number

#### Options ####
  * `true` - Passing just `true` will activate validation and use default message
  * `allowBlank` - If `true` skips validation if value is empty
  * `onlyInteger` - Will only allow integers
  * `greaterThan` - Ensures the value is greater than
  * `greaterThanOrEqualTo` - Ensures the value is greater than or equal to
  * `equalTo` - Ensures the value is equal to
  * `lessThan` - Ensures the value is less than
  * `lessThanOrEqualTo` - Ensures the value is less than or equal to
  * `odd` - Ensures the value is odd
  * `even` - Ensures the value is even

##### Messages #####
  * `greaterThan` - Message used when value failes to be greater than. Overrides `i18n`
  * `greaterThanOrEqualTo` - Message used when value failes to be greater than or equal to. Overrides `i18n`
  * `equalTo` - Message used when value failes to be equal to. Overrides `i18n`
  * `lessThan` - Message used when value failes to be less than. Overrides `i18n`
  * `lessThanOrEqualTo` - Message used when value failes to be less than or equal to. Overrides `i18n`
  * `odd` - Message used when value failes to be odd. Overrides `i18n`
  * `even` - Message used when value failes to be even. Overrides `i18n`

```javascript
// Examples
numericality: true
numericality: { odd: true, messages: { odd: 'must be an odd number' } }
numericality: { onlyInteger: true, greaterThan: 5, lessThanOrEqualTo : 10 }
```

### Presence ###
Validates the property has a value that is not `null`, `undefined`, or `''`

#### Options ####
  * `true` - Passing just `true` will activate validation and use default message
  * `message` - Any string you wish to be the error message. Overrides `i18n`.

```javascript
// Examples
presence: true
presence: { message: 'must not be blank' }
```

### Uniqueness ###

*Not yet implemented.*

### Conditional Validators ##
*not implemented yet*
Each validator can take an `if` or an `unless` in its `options` hash.
The value of the conditional can be an inline function, a string that
represents a property on the object, or a string that represents a
function on the object. The result should be a boolean.

**note that `if` is considered a keyword in IE8 and so you should put it
in quotes**

```javascript
// function form
firstName: {
  presence: {
    'if': function(object, validator) {
      return true;
    }
  }
}

// string form
// if 'canValidate' is a function on the object it will be called
// if 'canValidate' is a property object.get('canValidate') will be called
firstName: {
  presence: {
    unless: 'canValidate'
  }
}
```

### Custom Validators ###

Custom (or inline) validators take an arbitrary function which allow you to decide how to validate your model.

Have your custom function return null or a promise resolving to a null if validation passes.

have your function return a string or a promise to a string if validation fails. 
```coffee
email:
  inline: (model) ->
    store.find "user", Ember.get(model, "email")
    .then (user) ->
      return if user.get("isMasterrace")
      "not master-race"
    .catch ->
      "cannot be found"
```


## Installation

* `git clone` this repository
* `npm install`
* `bower install`

## Running

* `ember server`
* Visit your app at http://localhost:4200.

## Running Tests

* `ember test`
* `ember test --server`

## Building

* `ember build`

For more information on using ember-cli, visit [http://www.ember-cli.com/](http://www.ember-cli.com/).