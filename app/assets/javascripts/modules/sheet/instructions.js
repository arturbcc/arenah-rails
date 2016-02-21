// Instructions initializes a qtip with the instructionss for
// the group.
//
// It always has a length of two columns and tries to position the instructions
// centralized, although it will shift the block it the need arises.
//
// The expected structure is as follows:
//
// <div class="attributes-group">
//   <h2 class="with_gutter">
//     <a class="attributes-group-instructions" href="javascript:;">
//       <i class="fa fa-info-circle"></i>
//     </a>
//     História
//     <br>
//   </h2>
//   ...
//     <table class="attributes-group-instructions-content">
//       <tbody>
//         <tr>
//           <td class="hidden">
//             <div class="qtip-titlebar">Title</div>
//             <div class="qtip-content">Here comes the instructions</div>
//           </td>
//         </tr>
//       </tbody>
//     </table>
//     ...
// </div>
define('instructions', [], function() {
  function Instructions(element) {
    this._applyInstructionsTo(element);
  };

  var fn = Instructions.prototype;

  fn._applyInstructionsTo = function(element) {
    element.qtip({
      style: {
        classes: 'qtip-bootstrap master-instruction qtip-bootstrap-2-columns'
      },
      content: {
        text: function(event, api) {
          var target = api.target.parents('.attributes-group').find(".attributes-group-instructions-content tr td.hidden");
          return target.html();
        }
      },
      position: {
        my: 'top center',
        at: 'bottom center',
        viewport: $("#sheet"),
        adjust: { method: 'shift' }
      }
    });
  };

  return Instructions;
});
