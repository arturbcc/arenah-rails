// SheetEditor is responsible to deal with changes on the character sheets.
//
// It knows which component to call when the user edits a specific attributes
// group, and is also responsible to change between view and edit mode. All
// classes that deal with groups can be found at ./editable-types/*.js
define('sheet-editor', ['game-system', 'editable-based', 'editable-bullet', 'editable-character-card',
  'editable-equipments', 'editable-mixed', 'editable-name-value', 'editable-rich-text',
  'editable-text'], function(GameSystem, EditableBased, EditableBullet, EditableCharacterCard,
  EditableEquipments, EditableMixed, EditableNameValue, EditableRichText, EditableText) {

  function SheetEditor(options = {}) {
    this.isMaster = options.isMaster || false;
    this.isSheetOwner = options.isSheetOwner || false;
    this.equipmentsUrl = options.equipmentsUrl || '';
    this.garbageItems = [];
    this.itemsToInclude = [];

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

    $.ajax({
      url: $('#sheet').data('update-url'),
      type: 'PATCH',
      dataType : 'html',
      contentType: "application/json",
      data: JSON.stringify(changes),
      success: function() {
        var editable = self.currentEditable;

        self._updateSheetWithNewValues(data, changes);
        self._leaveEditMode(data);

        if (editable.afterSave && typeof editable.afterSave === "function") {
          editable.afterSave(data, changes);
        }

        NotyMessage.show('Alterações salvas com sucesso', 3000, 'success');
      },
      error: function() {
        NotyMessage.show('Não foi possível alterar a ficha', 3000);
      }
    });
  };

  // After updating the sheet, there were two available options:
  //
  // * Close the modal and reopen it, to ensure all the groups and attributes
  //   would be recalculated. That would be the easiest implementation, but not
  //   the best user experience.
  //
  // * Reset all the values in the sheet using javascript, to ensure the data
  //   attributes of all groups are changed as well. It is a hard task, but
  //   exceeds by far the experience of real time editing.
  //
  // This method is an approach to follow through with the second
  // implementation.
  fn._updateSheetWithNewValues = function(data, changes) {
    var self = this;

    $.each(changes.character_attributes, function(_, change) {
      var attributeRows = data.attributesGroup.find('tr[data-attribute-name="' + change.attribute_name + '"]');

      // Change the equipmentModifier in the change so we can consider this
      // modifier when updating attributes that are based in the current one.
      var mainTableRow = $(attributeRows[0]);
      if (mainTableRow.data('equipment-modifier')) {
        change.equipmentModifier = parseInt(mainTableRow.data('equipment-modifier'));
      }

      $.each(attributeRows, function() {
        var tr = $(this),
            element = tr.find('a[data-editable-attribute]');

        // In groups with sourceType list, there are two panels with data: one
        // the users see in regular mode and one they see in edit mode. It is
        // important to keep both updated.
        if (element.length === 0) {
          element = tr.find('.text-right a');
        }

        if (element.data('editable-attribute') === 'text') {
          element.html(change.value);
        } else if (self.currentEditable.updateSheetWithNewValues && typeof self.currentEditable.updateSheetWithNewValues === 'function') {
          var equipmentModifier = parseInt(tr.data('equipment-modifier') || 0);
          self.currentEditable.updateSheetWithNewValues(element, change, equipmentModifier, tr);
        }
      });

      self._updateBasedAttributes(changes.group_name, change);
    });

    this._removeDeletedAttributes(data, changes);
    this._includeAddedAttributes(data, changes);
  };

  fn._removeDeletedAttributes = function(data, changes) {
    $.each(changes.deleted_attributes, function() {
      data.attributesGroup.find('tr[data-attribute-name="' + this + '"]').remove();
    });
  };

  fn._includeAddedAttributes = function(data, changes) {
    var self = this;

    $.each(changes.added_attributes, function(_, attribute) {
      var table = data.attributesGroup.find('[data-accept-edit-mode]'),
          container = data.attributesGroup.find('.editable-list-items').find('[data-attribute-name="' + attribute.name + '"]');
          tr = container.clone();

      if (self.currentEditable.formatAddedAttribute && typeof self.currentEditable.formatAddedAttribute === 'function') {
        self.currentEditable.formatAddedAttribute(tr.find('.text-right'));
      }

      tr.removeAttr('data-state');
      table.append(tr);
      self.currentEditable.sourceTypeList.activateTooltip(table, tr);
    });
  };

  // Once we update an attribute, we have to change the value of all attributes
  // that have it as a base. This is the HTML of a classic based attribute:
  //
  // <tr data-attribute-name="Swimming" data-points="27" data-value="32"
  //   data-base-attribute-group="Attributes" data-base-attribute-name="Agility">
  //
  // In this example, the base value is 5 (32 - 27). It is important to update
  // the `data-value` by adding the new attribute value (from the `change`
  // parameter) on the `data-points`. For example, if the base attribute
  // changed from 5 to 7, the new `data-value` must be 34.
  //
  // Parameters:
  //
  // - attributesGroupName: name of the group where the base attribute belongs.
  // - chance: the same structure returned in the `changesToSave` method. It
  //           will be a hash like this:
  //
  //           { attribute_name: 'Strength', field_name: 'points', value: 12 }
  fn._updateBasedAttributes = function(attributesGroupName, change) {
    var baseAttributeGroupOperator = '[data-base-attribute-group="' + attributesGroupName + '"]',
        baseAttributeOperator = '[data-base-attribute-name="' + change.attribute_name + '"]',
        basedAttributes = $('#sheet').find(baseAttributeGroupOperator + baseAttributeOperator);

    $.each(basedAttributes, function() {
      var tr = $(this),
          element = tr.find('.text-right a'),
          parts = element.text().split(' / '),
          newValue = parseInt(change.value) + parseInt(parts[0]),
          equipmentModifier = parseInt(change.equipmentModifier || 0),
          newText = parts[0] + ' / ' + (newValue  + equipmentModifier);

      element.text(newText);
      tr.attr('data-value', newValue);
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
  //   ],
  //   deleted_attributes: [
  //     'Perception',
  //     'Agility'
  //   ],
  //   added_attributes: [
  //     'Charisma'
  //   ]
  // }
  fn._changesToSave = function(data) {
    var inputs = data.attributesGroup.find('.editableform input:visible'),
        changes = { group_name: data.attributesGroup.data('group-name'), character_attributes: [] },
        // attributesNames control the names of the attributes already included
        // in the character_attributes array. If it appears a second time, the
        // change must be saved in the `total` field.
        attributesNames = [];

    $.each(inputs, function() {
      var input = $(this),
          tr = input.parents('tr[data-attribute-name]'),
          currentValue = input.val();

      if (tr.data('points') !== currentValue) {
        var fieldName = tr.data('field-to-update') || 'points',
            attributeName = tr.data('attribute-name');

        // If there are two inputs (e.g. when the attribute has an editable name
        // AND and editable value), the second one must be saved in the `total`
        // field.
        if (attributesNames.indexOf(attributeName) > -1) {
          fieldName = 'total';
        } else {
          attributesNames.push(attributeName);
        }

        changes.character_attributes.push({
          attribute_name: attributeName,
          field_name: fieldName,
          value: currentValue
        });
      }
    });

    var arrayIntersection = this._arraysIntersection(this.garbageItems, this.itemsToInclude);
    changes.deleted_attributes = this._arraysDifference(this.garbageItems, arrayIntersection);
    changes.added_attributes = this._arraysOfHashDifference(this.itemsToInclude, arrayIntersection);

    return changes;
  };

  fn._arraysIntersection = function(deletedAttributes, addedAttributes) {
    return $.map(addedAttributes, function(item) {
      return $.inArray(item.name, deletedAttributes) < 0 ? null : item.name;
    });
  };

  fn._arraysDifference = function(array1, array2) {
    var difference = [];

    $.grep(array1, function(el) {
      if ($.inArray(el, array2) == -1) {
        difference.push(el);
      }
    });

    return difference;
  };

  fn._arraysOfHashDifference = function(arrayOfHash, arrayOfNames) {
    return $.grep(arrayOfHash, function(item) {
      return $.inArray(item.name, arrayOfNames) == -1
    });
  };

  // Undo all the current changes. Once the changes are cancelled, the group
  // will leave the edit mode.
  fn._cancel = function(event) {
    var data = this.currentAttributesGroupData($(event.currentTarget));

    this._leaveEditMode(data);
    this._rollback();

    if (this.currentEditable && this.currentEditable.onCancel && typeof this.currentEditable.onCancel === "function") {
      this.currentEditable.onCancel(data);
    }
  };

  fn._leaveEditMode = function(data) {
    this._restoreGroupsOpacity();
    this.garbageItems = [];
    this.itemsToInclude = [];

    this.editButtons.show();
    data.attributesGroup.find('a[data-editable-attribute]').editable('hide');
    data.attributesGroup.find("[data-accept-edit-mode]").removeClass("edit-mode");
    data.save.hide();
    data.cancel.hide();
    data.edit.show();
  };

  fn._changeToEditMode = function(data) {
    var self = this,
        tabindexCounter = 1;

    this.garbageItems = [];
    this.itemsToInclude = [];
    $('[tabindex]').removeAttr('tabindex');
    $('[editable-current-item-description]').html('');
    var editableLinks = data.attributesGroup.find('a[data-editable-attribute]');

    editableLinks.editable('destroy');
    $.each(editableLinks, function() {
      var editableField = $(this).editable({
        toggle: 'manual',
        showbuttons: false,
        onblur: 'ignore',
        mode: 'inline',
        emptytext: ''
      }).on('shown', function(e, editable) {
        if (self.currentEditable && self.currentEditable.transform && typeof self.currentEditable.transform === 'function') {
          self.currentEditable.transform(editable);
        }

        self._preventEnterKey(editable);

        editable.input.$input.attr('tabindex', tabindexCounter++);
      });

      var lastValue = editableField.text();

      // For some reason, editable is losing the value and filling the
      // input with the wrong value. However, by setting the correct value
      // using the setValue method, it overrides the .html() (or .text()),
      // displaying an incorrect value in the label. To fix that, we have to
      // set the editable value and reset the .html.
      if (editableField.attr('data-value')) {
        editableField.editable('setValue', editableField.attr('data-value'));
      }
      editableField.html(lastValue);

      editableField.editable('show');
    });

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

  fn.addNewItem = function(groupName, attributeName, value) {
    var gameSystem = new GameSystem(),
        item = { name: attributeName },
        attribute = gameSystem.getAttribute(groupName, attributeName);

    if (attribute) {
      if (attribute.cost !== undefined) {
        item.cost = value;
      } else {
        item.points = value;
      }

      this.itemsToInclude.push(item);
    }
  };

  return SheetEditor;
});
