/**
 * @license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 * http://cdn.ckeditor.com/
 */


CKEDITOR.editorConfig = function (config) {
  config.toolbar_short = [
    { name: 'document', items: ['Source'] },
    { name: 'clipboard', groups: ['clipboard', 'undo'], items: ['Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo'] },
    { name: 'basicstyles', groups: ['basicstyles', 'cleanup'], items: ['Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat'] },
     { name: 'paragraph', groups: ['list', 'indent', 'blocks', 'align', 'bidi'], items: ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'] },
     { name: 'links', items: ['Link', 'Unlink', 'Anchor'] },
    { name: 'insert', items: ['Image', 'Table', 'HorizontalRule', 'Smiley', 'SpecialChar', 'PageBreak'] },
     { name: 'styles', items: ['Styles', 'Format', 'Font', 'FontSize'] },
     { name: 'colors', items: ['TextColor', 'BGColor'] },
     { name: 'tools', items: ['Maximize'] }

  ];

  config.toolbar_simple = [
    { name: 'basicstyles', groups: ['basicstyles', 'cleanup'], items: ['Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat'] },
     { name: 'paragraph', groups: ['list', 'indent', 'blocks', 'align', 'bidi'], items: ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'] },
     { name: 'links', items: ['Link', 'Unlink', 'Anchor'] },
    { name: 'insert', items: ['Image', 'Table', 'HorizontalRule', 'Smiley', 'SpecialChar', 'PageBreak'] },
     { name: 'styles', items: ['Styles', 'Format', 'Font', 'FontSize'] },
     { name: 'colors', items: ['TextColor', 'BGColor'] }
  ];

  config.toolbar_tiny = [
    { name: 'basicstyles', groups: ['basicstyles', 'cleanup'], items: ['Bold', 'Italic', 'Underline'] },
     { name: 'paragraph', items: ['JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'] },
     { name: 'links', items: ['Link', 'Unlink'] },
    { name: 'insert', items: ['Image', 'Table', 'Smiley'] },
     { name: 'styles', items: ['Font', 'FontSize'] },
     { name: 'colors', items: ['TextColor', 'BGColor'] }
  ];

  config.resize_enabled = false;
  config.disallowedContent = 'script *[onclick]'
};