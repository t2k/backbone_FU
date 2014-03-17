(function() {
  define(["msgbus", "marionette", "components/fu/show/controller"], function(msgBus, Marionette, Controller) {
    var API;
    API = {
      show: function(region, options) {
        return new Controller({
          region: region,
          options: options
        });
      }
    };
    return msgBus.commands.setHandler("component:fu:show", function(region, options) {
      console.log("passed-in:", options);
      return API.show(region, options);
    });
  });

}).call(this);
