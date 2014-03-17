(function() {
  define(function(require) {
    return {
      layout: require("text!apps/upload/show/templates/layout.htm"),
      title: require("text!apps/upload/show/templates/title.htm"),
      options: require("text!apps/upload/show/templates/options.htm")
    };
  });

}).call(this);
