(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["msgbus", "components/fu/show/views", "controller/_base", "components/fu/entities"], function(msgBus, Views, AppController) {
    var Controller;
    return Controller = (function(_super) {
      __extends(Controller, _super);

      function Controller() {
        return Controller.__super__.constructor.apply(this, arguments);
      }

      Controller.prototype.initialize = function(_options) {
        var options, region;
        region = _options.region, options = _options.options;
        this.fuEntities = msgBus.reqres.request("fu:entities", options);
        this.layout = this.getLayoutView();
        this.listenTo(this.layout, "show", (function(_this) {
          return function() {
            return _this.uploadRegion(_this.fuEntities);
          };
        })(this));
        return this.show(this.layout);
      };

      Controller.prototype.uploadRegion = function(collection) {
        var view;
        view = this.getUploadView(collection);
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
