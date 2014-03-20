(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['msgbus', 'marionette', 'apps/upload/show/templates'], function(msgBus, Marionette, Templates) {
    var _Layout, _options, _title;
    return {
      Title: _title = (function(_super) {
        __extends(_title, _super);

        function _title() {
          return _title.__super__.constructor.apply(this, arguments);
        }

        _title.prototype.template = _.template(Templates.title);

        return _title;

      })(Marionette.ItemView),
      Options: _options = (function(_super) {
        __extends(_options, _super);

        function _options() {
          return _options.__super__.constructor.apply(this, arguments);
        }

        _options.prototype.template = _.template(Templates.options);

        _options.prototype.triggers = {
          "click button": "button:clicked"
        };

        return _options;

      })(Marionette.ItemView),
      Layout: _Layout = (function(_super) {
        __extends(_Layout, _super);

        function _Layout() {
          return _Layout.__super__.constructor.apply(this, arguments);
        }

        _Layout.prototype.template = _.template(Templates.layout);

        _Layout.prototype.className = "container";

        _Layout.prototype.regions = {
          titleRegion: "#title-region",
          optionsRegion: "#options-region",
          uploadRegion: "#upload-region"
        };

        return _Layout;

      })(Marionette.Layout)
    };
  });

}).call(this);
