(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["msgbus", "apps/fu/show/views", "controller/_base", "entities/fileupload", "apps/ifacelog/app"], function(msgBus, Views, AppController) {
    var Controller, _ref;

    return Controller = (function(_super) {
      __extends(Controller, _super);

      function Controller() {
        _ref = Controller.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Controller.prototype.initialize = function(options) {
        var _this = this;

        this.fuEntities = msgBus.reqres.request("fu:entities", options);
        this.layout = this.getLayoutView();
        this.listenTo(this.layout, "show", function() {
          _this.titleRegion();
          _this.uploadRegion(_this.fuEntities);
          return _this.logRegion();
        });
        return this.show(this.layout, {
          loading: true
        });
      };

      Controller.prototype.titleRegion = function() {
        var view;

        view = this.getTitleView();
        return this.layout.titleRegion.show(view);
      };

      Controller.prototype.uploadRegion = function(collection) {
        var view;

        view = this.getUploadView(collection);
        this.listenTo(view, "childview:log:refresh", function(child, args) {
          return this.logRegion();
        });
        this.listenTo(view, "select:file", function(input) {
          return msgBus.reqres.request("fu:addToQueue", input);
        });
        this.listenTo(view, "click:upload", function() {
          return msgBus.reqres.request("fu:queue:upload");
        });
        this.listenTo(view, "click:clearall", function() {
          return msgBus.reqres.request("fu:queue:empty");
        });
        return this.layout.uploadRegion.show(view);
      };

      Controller.prototype.logRegion = function() {
        return msgBus.commands.execute("app:ifacelog:list", this.layout.logRegion);
      };

      Controller.prototype.getTitleView = function() {
        return new Views.Title;
      };

      Controller.prototype.getLogView = function(collection) {
        return new Views.LogView({
          collection: collection
        });
      };

      Controller.prototype.getUploadView = function(collection) {
        return new Views.UploadView({
          collection: collection
        });
      };

      Controller.prototype.getLayoutView = function() {
        return new Views.Layout;
      };

      return Controller;

    })(AppController);
  });

}).call(this);
