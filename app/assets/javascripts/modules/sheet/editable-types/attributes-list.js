define('attributes-list', [], function() {
  function AttributesList(items = []) {
    this.positives = '';
    this.negatives = '';

    var self = this;
    $.each(items, function() { self.add(this); });
  };

  var fn = AttributesList.prototype;

  fn.add = function(item) {
    //parent
    var name = item.name;

    // if (parent.onSelectItemName && typeof parent.onSelectItemName === 'function') {
    //   name = parent.onSelectItemName(item);
    // }

    var abbreviation = item.abbreviation ? '_' + item.abbreviation : '',
        value = item.cost, //  || item.points
        text = value ? name + ' ' + value : name;

    if (value >= 0) {
      this.positives += "<option value='" + item.name + "_" + value + abbreviation + "'>" + text + "</option>";
    }
    else {
      this.negatives += "<option value='" + item.name + "_" + value + abbreviation + "'>" + text + "</option>";
    }
  };

  fn.toString = function() {
    if (this.positives === '' || this.negatives === '') {
      return this.positives + this.negatives;
    } else {
      var list = "<optgroup label='Positivos'>" + this.positives + "</optgroup>" +
        "<optgroup label='Negativos'>" + this.negatives + "</optgroup>";

      return list;
    }
  }

  return AttributesList;
});
