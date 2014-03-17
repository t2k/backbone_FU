(function() {
  define(function(require) {
    return {
      layout: require("text!apps/about/show/templates/layout.htm"),
      about: require("text!apps/about/show/templates/about.htm")
    };
  });

}).call(this);
