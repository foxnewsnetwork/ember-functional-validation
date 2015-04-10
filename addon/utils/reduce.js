// Q: Why isn't this in coffee? Did you finally abandon your stubborn stupidity
// and decide to join the world of real js engineering?
// A: Yes and no, I really want ES6's TCO, and coffee doesn't declare functions
// like I would want it to... so, to not throw the baby out with the bath water
// (really, since I'm in California, where we have too many babies and not enough
// water, the saying should be flipped), I will just use JS for when I really need
// Babel's features

var slice = [].slice;

function reduce(arg, combiner, init) {
  var x, xs;
  x = arg[0];
  xs = 2 <= arg.length ? slice.call(arg, 1) : [];

  if (x == null) {
    return init;
  }
  return reduce(xs, combiner, combiner(init, x));
}

export default reduce;