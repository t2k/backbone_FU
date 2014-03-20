(function() {
  require.config({
    paths: {
      jquery: "../bower_components/jquery/dist/jquery",
      underscore: "../bower_components/underscore/underscore",
      backbone: "../bower_components/backbone/backbone",
      "backbone.babysitter": "../bower_components/backbone.babysitter/lib/amd/backbone.babysitter",
      "backbone.wreqr": "../bower_components/backbone.wreqr/lib/amd/backbone.wreqr",
      "backbone.syphon": "../bower_components/backbone.syphon/lib/amd/backbone.syphon",
      marionette: "../bower_components/marionette/lib/core/amd/backbone.marionette",
      text: "../bower_components/requirejs-text/text",
      spin: "../bower_components/spin.js/spin",
      jqueryspin: "../bower_components/spin.js/jquery.spin",
      bootstrap: "../bower_components/bootstrap/dist/js/bootstrap",
      moment: "../bower_components/moment/moment",
      globalize: "../bower_components/globalize/lib/globalize"
    },
    shim: {
      bootstrap: ["jquery"],
      globalize: ["jquery"]
    }
  }, require(["config/load", "app"], function(_config, app) {
    return app.start();
  }));

}).call(this);
