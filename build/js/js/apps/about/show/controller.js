(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["msgbus", "apps/about/show/views", "controller/_base"], function(msgBus, Views, AppController) {
    var Controller;
    return Controller = (function(_super) {
      __extends(Controller, _super);

      function Controller() {
        return Controller.__super__.constructor.apply(this, arguments);
      }

      Controller.prototype.initialize = function() {
        this.layout = this.getLayoutView();
        this.listenTo(this.layout, "show", (function(_this) {
          return function() {
            return _this.aboutRegion();
          };
        })(this));
        return this.show(this.layout);
      };

      Controller.prototype.aboutRegion = function() {
        var view;
        view = this.getAboutView();
        return this.layout.aboutRegion.show(view);
      };

      Controller.prototype.getAboutView = function() {
        return new Views.About;
      };

      Controller.prototype.getLayoutView = function() {
        return new Views.Layout;
      };

      return Controller;

    })(AppController);
  });

}).call(this);
