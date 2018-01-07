define('source-list', [], function() {
  function SourceList() {
    this.positives = '';
    this.negatives = '';
  };

  var fn = SourceList.prototype;

  fn.add = function(parent) {
    var name = item.name;

    if (parent.onSelectItemName && typeof parent.onSelectItemName === 'function') {
      name = parent.onSelectItemName(item);
    }

    var abbreviation = item.abbreviation ? '_' + item.abbreviation : '';

    if (item.points >= 0)
      this.positives += "<option value='" + item.id + "_" + item.points + abbreviation + "'>" + name + "</option>";
    else
      this.negatives += "<option value='" + item.id + "_" + item.points + abbreviation + "'>" + name + "</option>";
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

  return SourceList;
});
