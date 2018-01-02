define('source-type-list', ['source-list'], function(SourceList) {
  function SourceTypeList(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
    this._backupContent = null;

    this._initialize(data);
  };

  var fn = SourceTypeList.prototype;

  fn._initialize = function(data) {
    this._setEditMode(data);
    // this._loadSources(data);
    this._startDragAndDrop(data);
    this._backup(data);
  };

  fn._backup = function(data) {
    this._backupContent = data.attributesGroup.find('.editable-list-group').html();
  };

  fn._rollback = function(data) {
    data.attributesGroup.find('.editable-list-group').html(this._backupContent);
  };

  fn._setEditMode = function(data) {
    var editContainer = data.attributesGroup.find('.editable-list-group');
    editContainer.addClass('edit-mode').removeClass('hidden');
    data.attributesGroup.find('[data-accept-edit-mode]').hide();
  };

  fn.onCancel = function(data) {
    data.attributesGroup.find('[data-accept-edit-mode]').show();
    data.attributesGroup.find('.editable-list-group').addClass('hidden');
    data.attributesGroup.find('[data-editable-attribute]').each(function() {
      $(this).editable('hide');
    });
    this._rollback(data);
  };

  fn.transform = function(editable) {
    editable.$element.editable('hide');
  };

  // fn._loadSources = function(data) {
  //   var self = this,
  //       editContainer = data.attributesGroup.find('.editable-list-group'),
  //       select = editContainer.find('select'),
  //       gameSlug = $('#game-room').val(),
  //       groupName = data.attributesGroup.data('group-name'),
  //       groupId = data.attributesGroup.data('group-id');
  //
  //   $.post("/" + gameSlug + "/atributos/fontes", { "attributesGroupId": groupId }).done(function (sources) {
  //     select.html("<option value='0'>Selecione...</option>");
  //     var sourceList = new SourceList(self);
  //
  //     $.each(sources, function () {
  //       var item = $(this).get(0);
  //       sourceList.add(item);
  //     });
  //
  //     select.append(sourceList.toString());
  //     select = select.select2({ width: "70%" });
  //     self.configureNewItem(data);
  //
  //     select.on("change", function () {
  //       var index = select.prop("selectedIndex");
  //       var descriptionContainer = $(this).siblings(".editable-current-item-description");
  //       descriptionContainer.html("");
  //       if (index > 0) {
  //         var name = $(this).select2('data').text;
  //         var parts = $(this).val().split("_");
  //         var points = parts[1];
  //         var abbreviation = parts.length > 2 ? parts[2] : "";
  //         name = self._removeAbbreviation(name, abbreviation);
  //         var style = "width: 90%; margin: 5px auto; padding: 5px; border: 1px solid #000; background-color: #fff; box-shadow: 3px 3px 3px #675D5D";
  //         var content = '<table style="' + style + '"><tr><td>' +
  //           '<div class="qtip-titlebar">' + name + '</div>' +
  //           '<div class="qtip-content">' + self._fetchItemDescription(sources, name) + '</div>' +
  //           '</td></tr></table>';
  //         descriptionContainer.html(content);
  //       }
  //     });
  //   });
  // };

  // fn._removeAbbreviation = function(name, abbreviation) {
  //   var abbreviation = " (" + (abbreviation == "" ? "0" : abbreviation) + ")";
  //   return name.replace(abbreviation, "");
  // };
  //
  // fn._fetchItemDescription = function(list, name) {
  //   var item = $.grep(list, function (item) { return item.Name == name; });
  //   return item != undefined && item[0].Description ? item[0].Description : "Sem descrição";
  // };
  //

  fn._startDragAndDrop = function(data) {
    var editContainer = data.attributesGroup.find('.editable-list-group'),
        garbage = editContainer.find('.editable-drop-item-area'),
        tooltips = editContainer.find('.smart-description'),
        validDraggableItems = '.editable-list-group[data-group-name=' + data.attributesGroup.data('group-name') + "] tr:not('.prevent-delete')",
        self = this;

    if (!this.sheetEditor.isMaster && !this.sheetEditor.freeMode) {
      $(validDraggableItems).not('[data-state=new]').addClass('prevent-delete');
    }

    editContainer.find('tr[data-attribute-name]').draggable({
      revert: 'invalid',
      start: function(event, ui) {
        ui.helper.css('z-index', 50);
        tooltips.qtip('hide').qtip('disable');
      },
      stop: function(event, ui) {
        ui.helper.css('z-index', 1);
        tooltips.qtip('enable');
      }
    });

    garbage.droppable({
      accept: validDraggableItems,
      hoverClass: 'ui-state-hover',
      drop: function(event, ui) {
        var points = parseInt(ui.draggable.data('points'));

        data.usedPoints = data.usedPoints - points;
        self.sheetEditor.changeAttributePoints(data);
        ui.draggable.remove();
      }
    });
  };

  fn._configureNewItem = function(data) {
    var editContainer = data.attributesGroup.find('.editable-list-group'),
        select = editContainer.find('select'),
        addButton = editContainer.find('.add-editable-list-item'),
        self = this;

    addButton.unbind().click(function () {
      var index = select.prop('selectedIndex'),
          name = select.select2('data').text,
          parts = select.val().split('_'),
          points = parseInt(parts[1]),
          abbreviation = parts.length > 2 ? parts[2] : '';

      name = self._removeAbbreviation(name, abbreviation);

      var exceededLimit = data.points && data.usedPoints + points > data.points;

      if (this.sheetEditor.isMaster) {
        exceededLimit = false;
      }

      if (index > 0) {
        if (!exceededLimit) {
          var template = $(".editable-list-group[data-group-name=" + data.attributesGroup.attr("data-group-name") + "]").find(".template.hidden:first").clone(),
              items = editContainer.find(".name-value-attributes"),
              description = editContainer.find(".editable-current-item-description .qtip-content").html(),
              newItem = self._fillTemplate(template, name, abbreviation, points, description);

          items.append(newItem);

          data.usedPoints = data.usedPoints + parseInt(points);
          self.sheetEditor.changeAttributePoints(data);
          self._newItemTooltip(editContainer, template);
          self._newItemMouseOver(template);
          self.startDragAndDrop(data);
          editContainer.find('.editable-current-item-description').html('');
          select.select2('val', '0');

          if (self.onNewItem && typeof self.onNewItem == "function") {
            self.onNewItem(newItem);
          }
        } else {
          NotyMessage.show('Você não possui pontos para adicionar este atributo', 3000);
        }
      } else {
        NotyMessage.show('Escolha um item na lista antes de adicioná-lo', 3000, 'info');
      }
    });
  };

  fn._newItemTooltip = function(editContainer, template) {
    var columns = editContainer.parents('[data-columns]:first').attr('data-columns');
    SheetTools.initializeTooltips(template.find('.smart-description'), columns);
  };

  fn._newItemMouseOver = function(template) {
    $(template).mouseenter(function() {
      $(this).addClass('success');
    }).mouseleave(function() {
      $(this).removeClass('success');
    });
  };

  fn._inputNewItem = function(container, points) {
    container.text(points);
  },

  fn._fillTemplate = function(template, name, abbreviation, points, description) {
    template.removeClass('template').removeClass('hidden');
    template.attr('data-attribute-name', name);
    template.attr('data-attribute-abbreviation', abbreviation);
    template.attr('data-points', points);
    template.attr('data-state', 'new');
    template.removeClass('prevent-delete');
    template.find('.smart-description').text(name);

    var textRight = template.find('.text-right');

    if (textRight.length > 0) {
      this.inputNewItem(textRight, points);
    }

    template.find('.qtip-titlebar').text(name);
    template.find('.qtip-content').html(description);

    return template;
  };

  return SourceTypeList;
});
