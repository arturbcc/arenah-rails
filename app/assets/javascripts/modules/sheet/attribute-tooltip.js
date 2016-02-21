// Attribute Tooltip initializes a qtip on an attribute with a description.
//
// It changes the class of the tooltip according to the column in which the
// attribute is, to make sure the content will be displayed in the best position
// and avoiding opening it beyond the viewport.
//
// The expected structure is as follows:
//
// <tr>
//   <td>
//     <a class="smart-description" href="javascript:;">
//       Sedução (Car)
//     </a>
//   </td>
//   ...
//   <td class="hidden">
//     <div class="qtip-titlebar">Sedução</div>
//     <div class="qtip-content"><b>Sedução</b> é a capacidade de encantar o outro com fins de atingir determinados objetivos.</div>
//   </td>
// </tr>
define('attribute-tooltip', [], function() {
  function AttributeTooltip(element) {
    this._applyTooltipTo(element);
  };

  var fn = AttributeTooltip.prototype;

  fn._applyTooltipTo = function(element) {
    var row = element.parent().parent(),
        columns = row.parents('[data-columns]').data('columns');

    element.qtip({
      style: {
        classes: 'qtip-bootstrap qtip-bootstrap-' + columns + '-columns'
      },
      content: {
        text: function (event, api) {
          return row.find('.hidden').html();
        }
      },
      position: {
        my: 'top left',
        at: 'bottom left'
      }
    });
  };

  return AttributeTooltip;
});
