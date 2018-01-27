// SheetEditor is responsible to deal with changes on the character sheets.
//
// It knows which component to call when the user edits a specific attributes
// group, and is also responsible to change between view and edit mode. All
// classes that deal with groups can be found at ./editable-types/*.js
define('sheet-editor', ['editable-based', 'editable-bullet', 'editable-character-card',
  'editable-equipments', 'editable-mixed', 'editable-name-value', 'editable-rich-text',
  'editable-text'], function(EditableBased, EditableBullet, EditableCharacterCard,
  EditableEquipments, EditableMixed, EditableNameValue, EditableRichText, EditableText) {

  function SheetEditor(options = {}) {
    this.isMaster = options.isMaster || false;
    this.isSheetOwner = options.isSheetOwner || false;
    this.equipmentsUrl = options.equipmentsUrl || '';

    // Valid sheet modes are: game_master_mode, free_mode and game_mode
    this.sheetMode = options.sheetMode || 'game_master_mode';
    this._createAliasForSheetModes();

    this.currentEditable = null;
    this._backupData = null;
    this.editableTypes = {
      based: EditableBased,
      bullet: EditableBullet,
      character_card: EditableCharacterCard,
      equipments: EditableEquipments,
      mixed: EditableMixed,
      name_value: EditableNameValue,
      rich_text: EditableRichText,
      text: EditableText
    };

    this.editButtons = $('.editable-edit', '#sheet');
    this.saveButtons = $('.editable-submit', '#sheet');
    this.cancelButtons = $('.editable-cancel', '#sheet');
    this.attributesGroups = $('.attributes-group', '#sheet');

    this._defineAuthorizationLevel();
    this._showLegendForModifiedAttributes();
    this._bindEvents();
  };

  var fn = SheetEditor.prototype;

  fn._bindEvents = function() {
    $.proxyAll(
      this,
      '_changeToEditMode',
      '_edit',
      '_save',
      '_cancel'
    );

    this.editButtons.on('click', this._edit);
    this.saveButtons.on('click', this._save);
    this.cancelButtons.on('click', this._cancel);
  };

  // All changes in the attributes should pass through this method. It grants
  // the modifications change the DOM in the correct form and this ensures that
  // the `currentAttributesGroupData` method will always return the correct
  // data.
  //
  // The `data` parameter is expected to have the structure returned by the
  // `currentAttributesGroupData` method.
  fn.changeAttributePoints = function(data) {
    data.attributesGroup.attr('data-used-points', data.usedPoints);
    var pointsCounter = data.attributesGroup.find('.points-counter');

    if (pointsCounter) {
      pointsCounter.html(data.usedPoints);
      pointsCounter.removeClass('exceeded-points').removeClass('available-points');

      if (data.usedPoints < data.points) {
        pointsCounter.addClass('available-points');
      }
      else if (data.usedPoints > data.points) {
        pointsCounter.addClass('exceeded-points');
      }
    }
  };

  // Public: Format data based on the data attributes of the group that contains
  // the given element. Every method that controls points during sheet edition
  // should use this method to retrieve data. The current state of the group's
  // points are managed through data attributes.
  //
  // - element: any element inside the attributes group from which we are trying
  //   to fetch data.
  //
  // Example:
  //
  // var data = this.sheetEditor.currentAttributesGroupData(select);
  //
  // => {
  //      attributesGroup: ...,
  //      cancel: ...,
  //      edit: ...,
  //      points: 7,
  //      save: ...,
  //      usedPoints: 5
  //    }
  fn.currentAttributesGroupData = function(element) {
    var attributesGroup = $(element).parents('.attributes-group'),
        manageContainer = attributesGroup.find('.manage-attributes-group'),
        edit = manageContainer.find('.editable-edit'),
        save = manageContainer.find('.editable-submit'),
        cancel = manageContainer.find('.editable-cancel'),
        points = parseInt(attributesGroup.attr('data-points')),
        usedPoints = parseInt(attributesGroup.attr('data-used-points'));

    return {
      'attributesGroup': attributesGroup,
      'edit': edit,
      'save': save,
      'cancel': cancel,
      'points': points,
      'usedPoints': usedPoints
    };
  };

  // Change the attributes group to edit mode, allowing users to add, modify and
  // remove attributes. It will respect the sheet_mode restrictions.
  fn._edit = function(event) {
    var element = $(event.currentTarget),
        data = this.currentAttributesGroupData(element),
        groupType = data.attributesGroup.data('type');

    this._focusOnGroup(data.attributesGroup);

    this._backup(data);
    this.editButtons.hide();

    if (groupType) {
      this.currentEditable = null;

      if (this.editableTypes[groupType]) {
        this.currentEditable = new this.editableTypes[groupType](this, data);
      }
    }

    this._changeToEditMode(data);
  };

  // Save the current changes in the character sheet. The changes cannot be
  // undone. Once the group is saved, it will leave the edit mode.
  fn._save = function(event) {
    var element = $(event.currentTarget),
        data = this.currentAttributesGroupData(element),
        changes = this._changesToSave(data),
        self = this;

    // TODO: on the backend, check if the user is master or character owner
    // before saving.
    // TODO: it would be a nice feature to log modifications to show to the
    // game master

    $.ajax({
      url: $('#sheet').data('update-url'),
      type: 'PATCH',
      dataType : 'html',
      contentType: "application/json",
      data: JSON.stringify(changes),
      success: function() {
        var editable = self.currentEditable;

        if (editable.onSave && typeof editable.onSave === "function") {
          self.currentEditable.onSave(changes);
        }

        element.siblings('.editable-cancel:first').trigger('click');

        NotyMessage.show('Alterações salvas com sucesso', 3000, 'success');
      },
      error: function() {
        NotyMessage.show('Não foi possível alterar a ficha', 3000);
      }
    });
  };

  // Collect data from the current attribute's group html to save in the
  // character sheet.
  //
  // Returns a structure with the following contract:
  //
  // {
  //   group_name: 'Skills',
  //   character_attributes: [
  //     { attribute_name: 'Strength', field_name: 'points', value: 12 },
  //     ...
  //   ]
  // }
  fn._changesToSave = function(data) {
    var inputs = data.attributesGroup.find('.editableform input'),
        changes = { group_name: data.attributesGroup.data('group-name'), character_attributes: [] };

    $.each(inputs, function() {
      var input = $(this),
          tr = input.parents('tr[data-attribute-name]');

      changes.character_attributes.push({
        attribute_name: tr.data('attribute-name'),
        field_name: tr.data('field-to-update'),
        value: input.val()
      });
    });

    return changes;
  };

  // Undo all the current changes. Once the changes are cancelled, the group
  // will leave the edit mode.
  fn._cancel = function(event) {
    this._restoreGroupsOpacity();

    this.editButtons.show();

    var data = this.currentAttributesGroupData($(event.currentTarget));

    data.attributesGroup.find('a[data-editable-attribute]').editable('hide');
    data.attributesGroup.find("[data-accept-edit-mode]").removeClass("edit-mode");
    data.save.hide();
    data.cancel.hide();
    data.edit.show();
    this._rollback();

    if (this.currentEditable && this.currentEditable.onCancel && typeof this.currentEditable.onCancel == "function") {
      this.currentEditable.onCancel(data);
    }
  };

  fn._changeToEditMode = function(data) {
    var self = this,
        tabindexCounter = 1;

    $('[tabindex]').removeAttr('tabindex');

    data.attributesGroup.find('a[data-editable-attribute]').editable('destroy');
    data.attributesGroup.find('a[data-editable-attribute]').editable({
      toggle: 'manual',
      showbuttons: false,
      onblur: 'ignore',
      mode: 'inline',
      emptytext: '',
    }).on('shown', function(e, editable) {
      if (self.currentEditable && self.currentEditable.transform && typeof self.currentEditable.transform === 'function') {
        self.currentEditable.transform(editable);
      }

      self._preventEnterKey(editable);

      editable.input.$input.attr('tabindex', tabindexCounter++);
    });

    data.attributesGroup.find('a[data-editable-attribute]').editable('show');
    data.attributesGroup.find('[data-accept-edit-mode]').addClass('edit-mode');
    data.attributesGroup.find('input[tabindex=1]').focus();
    data.save.show();
    data.cancel.show();
    data.edit.hide();
  };

  // Prevent users to close the edit mode when they press the ENTER key.
  // They have to save the group on the group's save button.
  fn._preventEnterKey = function(editable) {
    editable.input.$input.keypress(function(e) {
      if (e.which == 13) {
        return false;
      }
    })
  };

  // Define the changes that the current logged user can make in the character
  // sheet. It prevents a user to change other people's sheet and also grant
  // permissions based on the sheet mode of the character. Game masters have
  // a free pass to change anything at any time.
  fn._defineAuthorizationLevel = function() {
    var manageGroupContainer = $('.manage-group-container');

    if (this.isMaster || this.isSheetOwner) {
      manageGroupContainer.show();
    } else {
      manageGroupContainer.remove();
    }

    if (!this.isMaster) {
      $('[data-master-only=true]').removeAttr('data-editable-attribute');

      if (this.gameMode) {
        this._removeNotEditableFields();
        this._blockEditionOnGroupsWithNullOrNegativePoints();
        this._blockEditionOnGroupsOfTypeOpen();
      } else if (this.gameMasterMode) {
        manageGroupContainer.remove();
      }
    }
  };

  fn._removeNotEditableFields = function() {
    $('[data-editable-attribute=text]').removeAttr('data-editable-attribute');
    $('.attributes-group[data-editable-only-on-free-mode]').find('.manage-group-container').remove();
  };

  fn._blockEditionOnGroupsWithNullOrNegativePoints = function() {
    var groups = $('.attributes-group');

    $.each(groups, function() {
      var element = $(this),
          type = element.data('type'),
          points = parseInt(element.data('points')),
          usedPoints = parseInt(element.data('used-points')),
          groupWithoutPoints = element.data('points') == null,
          hasPointsToSpend = groupWithoutPoints || usedPoints >= points;

      if (hasPointsToSpend && type != 'equipments') {
        $('.manage-group-container', this).remove();
      }
    });
  };

  fn._blockEditionOnGroupsOfTypeOpen = function() {
    $('[data-source-type="open"] .manage-group-container').remove();
  };

  fn._backup = function(data) {
    this._backupData = $.extend({}, data);
  };

  fn._rollback = function() {
    if (this._backupData) {
      this.changeAttributePoints(this._backupData);
      this._clearStash();
    }
  };

  fn._clearStash = function() {
    this._backupData = null;
  },

  fn._focusOnGroup = function(group) {
    this.attributesGroups.css({ opacity: 0.2 });
    group.css({ opacity: 1 });
  };

  fn._restoreGroupsOpacity = function() {
    this.attributesGroups.css({ opacity: 1 });
  };

  fn._createAliasForSheetModes = function() {
    this.freeMode = this.sheetMode == 'free_mode';
    this.gameMode = this.sheetMode == 'game_mode';
    this.gameMasterMode = this.sheetMode == 'game_master_mode';
  };

  fn._showLegendForModifiedAttributes = function() {
    var self = this,
        texts = {
          decreased: 'Atributo penalizado por item equipado',
          increased: 'Atributo com bônus de item equipado'
        };

    $.each($('.decreased, .increased'), function() {
      var element = $(this),
          legendContainer = self._findOrCreateLegendContainer(element),
          klass = element.attr('class'),
          mark = $('<span>').addClass(klass + '-mark').text('*');

      if (legendContainer.find('.' + klass + '-mark').length == 0) {
        legendContainer.append($('<p>').append(mark).append(' ' + texts[klass]));
      }
    });
  };

  fn._findOrCreateLegendContainer = function(element) {
    var attributesGroup = element.parents('.attributes-group'),
        container = attributesGroup.find('.attributes-group-legend');

    if (container.length == 0) {
      container = $('<div>').addClass('attributes-group-legend');
      element.parents('.attributes-group').append(container);
    }

    return container;
  };

  return SheetEditor;
});
