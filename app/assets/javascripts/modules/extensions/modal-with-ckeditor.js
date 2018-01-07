/*
 CKEditor inside a bootstrap modal has some issues and malfunctions. It will
 open the image properties dialog, but all inputs are disabled, for example.

 To fix this problem, I used the following code suggest by Pavel Kovalev in
 this URL:
 https://stackoverflow.com/questions/22637455/how-to-use-ckeditor-in-a-bootstrap-modal
*/

$.fn.modal.Constructor.prototype.enforceFocus = function () {
    var $modalElement = this.$element;
    $(document).on('focusin.modal', function (e) {
        var $parent = $(e.target.parentNode);
        if ($modalElement[0] !== e.target && !$modalElement.has(e.target).length
            &&
            !$parent.hasClass('cke_dialog_ui_input_select') && !$parent.hasClass('cke_dialog_ui_input_text')) {
            $modalElement.focus()
        }
    })
};
