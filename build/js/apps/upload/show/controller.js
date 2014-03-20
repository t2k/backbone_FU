(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["msgbus", "backbone", "apps/upload/show/views", "controller/_base", "components/fu/app", "backbone.syphon"], function(msgBus, Backbone, Views, AppController) {
    var Controller;
    return Controller = (function(_super) {
      __extends(Controller, _super);

      function Controller() {
        return Controller.__super__.constructor.apply(this, arguments);
      }

      Controller.prototype.initialize = function() {
        var model;
        model = msgBus.reqres.request("new:fuoptions:entity");
        this.layout = this.getLayoutView();
        this.listenTo(this.layout, "show", (function(_this) {
          return function() {
            _this.titleRegion();
            return _this.optionsRegion(model);
          };
        })(this));
        return this.show(this.layout);
      };

      Controller.prototype.titleRegion = function() {
        var view;
        view = this.getTitleView();
        return this.layout.titleRegion.show(view);
      };

      Controller.prototype.optionsRegion = function(model) {
        var view;
        view = this.getOptionsView(model);
        this.listenTo(view, "button:clicked", (function(_this) {
          return function() {
            var data;
            data = Backbone.Syphon.serialize(view);
            return msgBus.commands.execute("component:fu:show", _this.layout.uploadRegion, data);
          };
        })(this));
        return this.layout.optionsRegion.show(view);
      };

      Controller.prototype.getTitleView = function() {
        return new Views.Title;
      };

      Controller.prototype.getOptionsView = function(model) {
        return new Views.Options({
          model: model
        });
      };

      Controller.prototype.getLayoutView = function() {
        return new Views.Layout;
      };

      return Controller;

    })(AppController);
  });

}).call(this);
