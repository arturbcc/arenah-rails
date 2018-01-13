// The positive-negative method will separate values according to the sign
// of the values.
//
// If the value is zero it will go into the positive list, and if the value is
// null it will be added to an unclassified list.
define('positive-negative-method', [], function() {
  function PositiveNegativeMethod() {
    this.data = {
      positives: { label: 'Positivos', list: [] },
      negatives: { label: 'Negativos', list: [] }
    };
  };

  var fn = PositiveNegativeMethod.prototype;

  fn.add = function(attribute, item) {
    var key = item.cost >= 0 ? 'positives' : 'negatives';

    this.data[key].list.push(attribute);
  };

  fn.accept = function(item) {
    return item.cost;
  };

  return PositiveNegativeMethod;
});
