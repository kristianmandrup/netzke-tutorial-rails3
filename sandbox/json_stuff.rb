s = %q{
  //<![CDATA[
          Ext.Ajax.extraParams = {authenticity_token: 'g+CJZkaaf0oMI1j5RlXlF3QyocKVwyPADGK8qCg6wVE='}; // Rails' forgery protection
                    if (!Netzke.classes) {
              Ext.ns("Netzke.classes");
            }
            Netzke.classes.JustAPanel = function(config){
              this.commonBeforeConstructor(config);
              Netzke.classes.JustAPanel.superclass.constructor.call(this, config);
              this.commonAfterConstructor(config);
            };
            Ext.extend(Netzke.classes.JustAPanel, Ext.Panel, Ext.applyIf({}, Ext.widgetMixIn));
            Ext.reg("netzkejustapanel", Netzke.classes.JustAPanel);
            if (!Netzke.classes) {
              Ext.ns("Netzke.classes");
            }
            Netzke.classes.GridPanel = function(config){
              this.commonBeforeConstructor(config);
              Netzke.classes.GridPanel.superclass.constructor.call(this, config);
              this.commonAfterConstructor(config);
            };
            Ext.extend(Netzke.classes.GridPanel, Ext.grid.EditorGridPanel, Ext.applyIf({trackMouseOver:true,loadMask:true,autoScroll:true,defaultColumnConfig:{},initComponent: function(){
                if (!this.clmns) {this.feedback('No columns defined for grid '+this.id);}
                var normClmns = [];
                Ext.each(this.clmns, function(c){
                  if (typeof c == 'string') {
                    normClmns.push({name:c});
                  } else {
                    normClmns.push(c);
                  }
                });
                delete this.clmns; 
                var cmConfig = []; 
                this.plugins = []; 
                var filters = [];
                Ext.each(normClmns, function(c){
                  if (c.meta) return;
                  Ext.applyIf(c, this.defaultColumnConfig);
                  c.dataIndex = c.name;
                  if (!c.header) {c.header = c.label || c.name.humanize()}
                  if (c.editor) {
                    c.editor = Netzke.isObject(c.editor) ? c.editor : {xtype:c.editor};
                  } else {
                    c.editor = {xtype: this.attrTypeEditorMap[c.attrType] || 'textfield'}
                  }
                  if (c.comboboxOptions && c.editor.xtype === "textfield") {
                    c.editor = {xtype: "combobox", options: c.comboboxOptions.split('\
  ')}
                  }
                  if (c.filterable){
                    filters.push({type:this.filterTypeForAttrType(c.attrType), dataIndex:c.name});
                  }
                  if (c.editor && c.editor.xtype == 'checkbox') {
                    var plugin = new Ext.ux.grid.CheckColumn(c);
                    this.plugins.push(plugin);
                    cmConfig.push(plugin);
                  } else {
                    if (!c.readOnly && !this.prohibitUpdate) {
                      var xtype = c.editor.xtype;
                      c.editor = Ext.ComponentMgr.create(Ext.apply({
                        parentId: this.id,
                        name: c.name,
                        selectOnFocus:true
                      }, c.editor));
                    } else {
                      c.editor = null;
                    }
                    this.normalizeRenderer(c);
                    cmConfig.push(c);
                  }
                }, this);
                this.cm = new Ext.grid.ColumnModel(cmConfig);
                if (this.persistentConfig) {this.cm.on('hiddenchange', this.onColumnHiddenChange, this);}
                if (this.enableColumnFilters) {
                 this.plugins.push(new Ext.ux.grid.GridFilters({filters:filters}));
                }
                this.recordConfig = [];
                Ext.each(normClmns, function(column){this.recordConfig.push({name:column.name, defaultValue:column.defaultValue});}, this);
                this.Row = Ext.data.Record.create(this.recordConfig);
                if (this.enableRowsReordering){
                  this.ddPlugin = new Ext.ux.dd.GridDragDropRowOrder({
                      scrollable: true 
                  });
                  this.plugins.push(this.ddPlugin);
                }
                var connection = new Ext.data.Connection({
                  url: this.buildApiUrl("get_data"),
                  extraParams: {
                    authenticity_token : Netzke.authenticityToken
                  },
                  listeners: {
                    beforerequest: function(){
                      Ext.Ajax.fireEvent('beforerequest', arguments);
                    },
                    requestexception: function(){
                      Ext.Ajax.fireEvent('requestexception', arguments);
                    },
                    requestcomplete: function(){
                      Ext.Ajax.fireEvent('requestcomplete', arguments);
                    }
                  }
                });
                connection.on('requestcomplete', function(conn, r){
                  var response = Ext.decode(r.responseText);
                  Ext.each(['data', 'total', 'success'], function(property){delete response[property];});
                  this.bulkExecute(response);
                }, this);
                var httpProxy = new Ext.data.HttpProxy(connection);
                this.store = new Ext.data.Store({
                    proxy: this.proxy = httpProxy,
                    reader: new Ext.data.ArrayReader({root: "data", totalProperty: "total", successProperty: "success", id:0}, this.Row),
                    remoteSort: true,
                    listeners:{'loadexception':{
                      fn:this.loadExceptionHandler,
                      scope:this
                    }}
                });
                this.bbar = (this.enablePagination) ? new Ext.PagingToolbar({
                  pageSize : this.rowsPerPage,
                  items : this.bbar ? ["-"].concat(this.bbar) : [],
                  store : this.store,
                  emptyMsg: 'Empty',
                  displayInfo: true
                }) : this.bbar;
                this.sm = new Ext.grid.RowSelectionModel();
                Netzke.classes.GridPanel.superclass.initComponent.call(this);
                if (this.persistentConfig) {
                  this.on('columnresize', this.onColumnResize, this);
                  this.on('columnmove', this.onColumnMove, this);
                }
                if (this.enableContextMenu) {
                  this.on('rowcontextmenu', this.onRowContextMenu, this);
                }
                if (this.loadInlineData) {
                  this.getStore().loadData(this.inlineData);
                  if (this.rowsPerPage) {
                    this.getStore().lastOptions = {params:{limit:this.rowsPerPage, start:0}}; 
                  }
                  Ext.each(['data', 'total', 'success'], function(property){delete this.inlineData[property];}, this);
                  this.bulkExecute(this.inlineData);
                }
                this.getSelectionModel().on('selectionchange', function(selModel){
                  this.actions.del.setDisabled(!selModel.hasSelection() || this.prohibitDelete);
                  this.actions.edit.setDisabled(selModel.getCount() != 1 || this.prohibitUpdate);
                }, this);
                if (this.enableRowsReordering){
                  this.ddPlugin.on('afterrowmove', this.onAfterRowMove, this);
                }
                this.getView().getRowClass = this.defaultGetRowClass;
                            if (this.enableEditInForm) {
                this.getSelectionModel().on('selectionchange', function(selModel){
                  var disabled;
                  if (!selModel.hasSelection()) {
                    disabled = true;
                  } else {
                    disabled = !selModel.each(function(r){
                      if (r.isNew) { return false; }
                    });
                  };
                  this.actions.editInForm.setDisabled(disabled);
                }, this);
              }
              }
  ,attrTypeEditorMap:{integer:"numberfield",boolean:"checkbox",decimal:"numberfield",datetime:"xdatetime",date:"datefield",string:"textfield"},filterTypeForAttrType : function(attrType){
                  var map = {
                    integer :'Numeric',
                    decimal :'Numeric',
                    datetime:'Date',
                    date    :'Date',
                    string  :'String'
                  };
                  map['boolean'] = "Boolean"; 
                  return map[attrType] || 'String';
                }
  ,onAdd : function(){
                  var r = new this.Row();
                  r.isNew = true; 
                  this.stopEditing();
                  this.getStore().add(r);
                  this.getStore().fields.each(function(field){
                    r.set(field.name, field.defaultValue);
                  });
                  this.tryStartEditing(this.store.indexOf(r));
                }
  ,onEdit : function(){
                  var row = this.getSelectionModel().getSelected();
                  if (row){
                    this.tryStartEditing(this.store.indexOf(row));
                  }
                }
  ,onDel : function() {
                  Ext.Msg.confirm('Confirm', 'Are you sure?', function(btn){
                    if (btn == 'yes') {
                      var records = [];
                      this.getSelectionModel().each(function(r){
                        if (r.isNew) {
                          this.store.remove(r);
                        } else {
                          records.push(r.id);
                        }
                      }, this);
                      if (records.length > 0){
                        this.deleteData({records: Ext.encode(records)});
                      }
                    }
                  }, this);
                }
  ,onApply : function(){
                  var newRecords = [];
                  var updatedRecords = [];
                  Ext.each(this.store.getModifiedRecords(),
                    function(r) {
                      if (r.isNew) {
                        newRecords.push(Ext.apply(r.getChanges(), {id:r.id}));
                      } else {
                        updatedRecords.push(Ext.apply(r.getChanges(), {id:r.id}));
                      }
                    }, 
                  this);
                  if (newRecords.length > 0 || updatedRecords.length > 0) {
                    var params = {};
                    if (newRecords.length > 0) {
                      params.created_records = Ext.encode(newRecords);
                    }
                    if (updatedRecords.length > 0) {
                      params.updated_records = Ext.encode(updatedRecords);
                    }
                    if (this.store.baseParams !== {}) {
                      params.base_params = Ext.encode(this.store.baseParams);
                    }
                    this.postData(params);
                  }
                }
  ,onRefresh : function() {
                  if (this.fireEvent('refresh', this) !== false) {
                    this.store.reload();
                  }
                }
  ,onColumnResize : function(index, size){
                  this.resizeColumn({
                    index:index,
                    size:size
                  });
                }
  ,onColumnHiddenChange : function(cm, index, hidden){
                  this.hideColumn({
                    index:index,
                    hidden:hidden
                  });
                }
  ,onColumnMove : function(oldIndex, newIndex){
                  this.moveColumn({
                    old_index:oldIndex,
                    new_index:newIndex
                  });
                  var newRecordConfig = [];
                  Ext.each(this.getColumnModel().config, function(c){newRecordConfig.push({name: c.name})});
                  delete this.Row; 
                  this.Row = Ext.data.Record.create(newRecordConfig);
                  this.getStore().reader.recordType = this.Row;
                }
  ,onRowContextMenu : function(grid, rowIndex, e){
                  e.stopEvent();
                  var coords = e.getXY();
                  if (!grid.getSelectionModel().isSelected(rowIndex)) {
                    grid.getSelectionModel().selectRow(rowIndex);
                  }
                  var menu = new Ext.menu.Menu({
                    items: this.contextMenu
                  });
                  menu.showAt(coords);
                }
  ,onAfterRowMove : function(dt, oldIndex, newIndex, records){
                  var ids = [];
                  Ext.each(records, function(r){ids.push(r.id)});
                  this.moveRows({ids:Ext.encode(ids), new_index: newIndex});
                }
  ,loadExceptionHandler : function(proxy, options, response, error){
                if (response.status == 200 && (responseObject = Ext.decode(response.responseText)) && responseObject.flash){
                  this.feedback(responseObject.flash);
                } else {
                  if (error){
                    this.feedback(error.message);
                  } else {
                    this.feedback(response.statusText);
                  }  
                }
              }        
  ,update : function(){
                  this.store.reload();
                }
  ,loadStoreData : function(data){
                  this.store.loadData(data);
                  Ext.each(['data', 'total', 'success'], function(property){delete data[property];}, this);
                  this.bulkExecute(data);
                }
  ,tryStartEditing : function(row){
                  var editableIndex = 0;
                  Ext.each(this.getColumnModel().config, function(c){
                    if (!(c.hidden == true || c.editable == false || !c.editor || c.attrType == 'boolean')) {
                      return false;
                    }
                    editableIndex++;
                  });
                  if (editableIndex < this.getColumnModel().config.length) {this.startEditing(row, editableIndex);}
                }
  ,updateNewRecords : function(records){
                  this.updateRecords(records);
                }
  ,updateModRecords : function(records){
                  this.updateRecords(records, true);
                }
  ,updateRecords : function(records, mod){
                  if (!mod) {mod = false;}
                  var modRecordsInGrid = [].concat(this.store.getModifiedRecords()); 
                  for (var k in records){
                    records[k] = this.store.reader.readRecords([records[k]]).records[0];
                  }
                  Ext.each(modRecordsInGrid, function(recordInGrid){
                    if (mod ^ recordInGrid.isNew) {
                      var recordId = recordInGrid.id;
                      var newData =  records[recordId];
                      if (newData){
                        for (var k in newData.data){
                          recordInGrid.set(k, newData.get(k));
                        }
                        recordInGrid.isNew = false;
                        recordInGrid.commit();
                      }
                    }
                  }, this);
                  this.getSelectionModel().clearSelections();
                  var modRecords = this.store.getModifiedRecords();
                  if (modRecords.length == 0) {
                    this.store.reload();
                    this.getView().getRowClass = this.defaultGetRowClass;
                  } else {
                    this.getView().getRowClass = function(r){
                      return r.dirty ? "grid-dirty-record" : ""
                    }
                  }
                  this.getView().refresh();
                  this.getSelectionModel().fireEvent('selectionchange', this.getSelectionModel());
                }
  ,defaultGetRowClass : function(r){
                  return r.isNew ? "grid-dirty-record" : ""
                }
  ,selectFirstRow : function(){
                  this.getSelectionModel().suspendEvents();
                  this.getSelectionModel().selectRow(0);
                  this.getSelectionModel().resumeEvents();
                }
  ,normalizeRenderer : function(c) {
                  if (!c.renderer) return;
                  var name, args = [];
                  if ('string' === typeof c.renderer) {
                    name = c.renderer;
                  } else {
                    name = c.renderer[0];
                    args = c.renderer.slice(1);
                  }
                  if (Ext.isFunction(Ext.util.Format[name])) {
                     c.renderer = Ext.util.Format[name].createDelegate(this, args, 1);
                  } else if (Ext.isFunction(this[name])) {
                    c.renderer = this[name].createDelegate(this, args, 1);
                  } else {
                    eval("c.renderer = " + c.renderer + ";");
                  }
                }
  ,onEditInForm : function(){
                  var selModel = this.getSelectionModel();
                  if (selModel.getCount() > 1) {
                    var recordId = selModel.getSelected().id;
                    this.loadAggregatee({id: "multiEditForm",
                      params: {record_id: recordId},
                      callback: function(w){
                        var form = w.items.first();
                        form.on('apply', function(){
                          var ids = [];
                          selModel.each(function(r){
                            ids.push(r.id);
                          });
                          form.baseParams = {ids: Ext.encode(ids)}
                        }, this);
                        w.on('close', function(){
                          if (w.closeRes === "ok") {
                            this.store.reload();
                          }
                        }, this);
                      }, scope: this});
                  } else {
                    var recordId = selModel.getSelected().id;
                    this.loadAggregatee({id: "editForm",
                      params: {record_id: recordId},
                      callback: function(form){
                        form.on('close', function(){
                          if (form.closeRes === "ok") {
                            this.store.reload();
                          }
                        }, this);
                      }, scope: this});
                  }
                }
  ,onAddInForm : function(){
                  this.loadAggregatee({id: "addForm\, callback : function(form){
                    form.on('close', function(){
                      if (form.closeRes === "ok") {
                        this.store.reload();
                      }
                    }, this);
                  }, scope: this});
                }
  ,onSearch : function(){
                  delete this.searchWindow;
                  this.searchWindow = new Ext.Window({
                    title:'Advanced search',
                    layout:'fit',
                    modal: true,
                    width: 400,
                    height: Ext.lib.Dom.getViewHeight() *0.9,
                    closeAction:'close',
                    buttons:[{
                      text: 'OK',
                      handler: function(){
                        this.ownerCt.ownerCt.closePositively();
                      }
                    },{
                      text:'Cancel',
                      handler:function(){
                        this.ownerCt.ownerCt.closeNegatively();
                      }
                    }],
                    closePositively : function(){
                      this.conditions = this.getWidget().getForm().getValues();
                      this.closeRes = 'OK'; 
                      this.close();
                    },
                    closeNegatively: function(){
                      this.closeRes = 'cancel'; 
                      this.close();
                    }
                  });
                  this.searchWindow.on('close', function(){
                    if (this.searchWindow.closeRes == 'OK'){
                      var searchConditions = this.searchWindow.conditions;
                      var filtered = false;
                      for (var k in searchConditions) {
                        if (searchConditions[k].length > 0) {
                          filtered = true;
                          break;
                        }
                      }
                      this.actions.search.setText(filtered ? "Search *" : "Search");
                      this.getStore().baseParams = {extra_conditions: Ext.encode(this.searchWindow.conditions)};
                      this.getStore().load();
                    }
                  }, this);
                  this.searchWindow.on('add', function(container, searchPanel){
                    searchPanel.on('apply', function(widget){
                      this.searchWindow.closePositively();
                      return false; 
                    }, this);
                  }, this);
                  this.searchWindow.show(null, function(){
                    this.searchWindow.closeRes = 'cancel';
                    if (!this.searchWindow.getWidget()){
                      this.loadAggregatee({id:"searchPanel", container:this.searchWindow.id});
                    }
                  }, this);
                }
  ,onGear : function(){
                var w = new Ext.Window({
                  title:'Config - '+ this.model,
                  layout:'fit',
                  modal:true,
                  width: Ext.lib.Dom.getViewWidth() *0.9,
                  height: Ext.lib.Dom.getViewHeight() *0.9,
                  closeAction:'destroy',
                  buttons:[{
                    text:'OK',
                    disabled: !this.configurable,
                    tooltip: this.configurable ? null : "No dynamic configuration for this component",
                    handler:function(){
                      w.closeRes = 'OK'; 
                      w.close();
                    }
                  },{
                    text:'Cancel',
                    handler:function(){
                      w.closeRes = 'cancel'; 
                      w.close();
                    }
                  }]
                });
                w.show(null, function(){
                  this.loadAggregatee({id:"configuration_panel", container:w.id});
                }, this);
                w.on('close', function(){
                  if (w.closeRes == 'OK'){
                    var configurationPanel = this.getChildWidget('configuration_panel');
                    var panels = configurationPanel.getLoadedChildren();
                    var commitData = {};
                    Ext.each(panels, function(p){
                      if (p.getCommitData) {commitData[p.localId(configurationPanel)] = p.getCommitData();}
                    }, this);
                    configurationPanel.commit({commit_data:Ext.encode(commitData)});
                  }
                }, this);
              }
  "}}


class String
  def repair_json
    s = self 
    return "" if !s
    
    s.gsub!(/""/, "''")      
    s.gsub!(/\"([^,]*?)\":/, '\1:')
    s.gsub!(/\\n/, "\n")       
    s.gsub!(/:"\s*?(function)/, ': function')
    s.gsub!(/",(.*?):\s*function/, ',\1 : function')
    s.gsub!(/"(.*?)\\/, '"\1"')
    s.gsub!(/:\s*"([^"]*?)\s*,/, ':"\1",')
    s.gsub!(/\\"/, '"')    
    s.gsub!(/"([^"]*?)""/, '"\1"')            
    s = s[0..-6] + s[-5..-1].gsub(/"}/, '}')
    s
  end
end
       
x = %q{
"\}, Ext.widgetMixIn));
}

puts "last s: " + s[-5..-1]

x.gsub! /"},\s*Ext.widgetMixIn/, '}, Ext.widgetMixIn'    
# puts x

puts s.repair_json
