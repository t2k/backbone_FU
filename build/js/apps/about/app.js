(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["msgbus", "marionette", "apps/about/show/controller"], function(msgBus, Marionette, Controller) {
    var API, Router;
    Router = (function(_super) {
      __extends(Router, _super);

      function Router() {
        return Router.__super__.constructor.apply(this, arguments);
      }

      Router.prototype.appRoutes = {
        "about": "show"
      };

      return Router;

    })(Marionette.AppRouter);
    API = {
      show: function() {
        return new Controller;
      }
    };
    return msgBus.commands.setHandler("start:about:app", function() {
      return new Router({
        controller: API
      });
    });
  });

}).call(this);