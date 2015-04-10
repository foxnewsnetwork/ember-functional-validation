`import Ember from 'ember'`

id = (model) ->
  new Ember.RSVP.Promise (resolve, reject) ->
    resolve model

`export default id`