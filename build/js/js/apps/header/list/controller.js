(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["msgbus", "apps/header/list/views", "controller/_base", "entities/header"], function(msgBus, View, AppController) {
    var Controller;
    return Controller = (function(_super) {
      __extends(Controller, _super);

      function Controller() {
        return Controller.__super__.constructor.apply(this, arguments);
      }

      Controller.prototype.initialize = function() {
        var headerView, links;
        links = msgBus.reqres.request("header:entities");
        headerView = this.getHeaderView(links);
        return this.show(headerView);
      };

      Controller.prototype.getHeaderView = function(links) {
        return new View.ListView({
          collection: links
        });
      };

      return Controller;

    })(AppController);
  });

}).call(this);
