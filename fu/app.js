(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["msgbus", "marionette", "apps/fu/show/controller"], function(msgBus, Marionette, Controller) {
    var API, Router, _ref;

    Router = (function(_super) {
      __extends(Router, _super);

      function Router() {
        _ref = Router.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Router.prototype.appRoutes = {
        "upload": "show"
      };

      return Router;

    })(Marionette.AppRouter);
    API = {
      show: function() {
        return new Controller({
          action: "ZDCashFlows",
          mimeTypes: "text/plain",
          queueSizeLimit: 1,
          fileDataName: "Filedata",
          handler: "/UploadHandler.ashx"
        });
      }
    };
    return msgBus.commands.setHandler("start:fu:app", function() {
      return new Router({
        controller: API
      });
    });
  });

}).call(this);
