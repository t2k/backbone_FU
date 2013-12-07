(function() {
  define(function(require) {
    return {
      layout: require("text!apps/fu/show/templates/layout.htm"),
      title: require("text!apps/fu/show/templates/title.htm"),
      fileupload: require("text!apps/fu/show/templates/fileupload.htm"),
      fuitem: require("text!apps/fu/show/templates/fuitem.htm"),
      fuempty: require("text!apps/fu/show/templates/fuempty.htm")
    };
  });

}).call(this);
