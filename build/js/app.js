(function() {
  define(["msgbus", "backbone", "apps/load"], function(msgBus, Backbone) {
    var app;
    app = new Backbone.Marionette.Application();
    app.rootRoute = "upload";
    app.addRegions({
      headerRegion: "#header-region",
      mainRegion: "#main-region"
    });
    app.on("initialize:before", function(options) {});
    msgBus.reqres.setHandler("default:region", function() {
      return app.mainRegion;
    });
    msgBus.reqres.setHandler("header:region", function() {
      return app.headerRegion;
    });
    msgBus.commands.setHandler("register:instance", function(instance, id) {
      return app.register(instance, id);
    });
    msgBus.commands.setHandler("unregister:instance", function(instance, id) {
      return app.unregister(instance, id);
    });
    app.on("initialize:after", function(options) {
      if (Backbone.history) {
        Backbone.history.start(options);
        if (this.getCurrentRoute() === null) {
          return this.navigate(this.rootRoute, {
            trigger: true
          });
        }
      }
    });
    app.addInitializer(function(options) {
      msgBus.commands.execute("start:header:app");
      msgBus.commands.execute("start:upload:app");
      return msgBus.commands.execute("start:about:app");
    });
    return app;
  });

}).call(this);
