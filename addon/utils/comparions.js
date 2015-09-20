function lessThan (a,b) {
  return a < b;
}

function greaterThan (a, b) {
  return a > b;
}

function equal(a,b) {
  return a === b;
}

function lessThanEqualTo (a, b) {
  return a <= b;
}

function greaterThanEqualTo (a, b) {
  return a >= b;
}

export default {
  lessThan: lessThan,
  greaterThan: greaterThan,
  equal: equal,
  lessThanEqualTo: lessThanEqualTo,
  greaterThanEqualTo: greaterThanEqualTo
};