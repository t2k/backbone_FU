(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['msgbus', 'marionette', 'apps/about/show/templates'], function(msgBus, Marionette, Templates) {
    var _Layout, _about;
    return {
      About: _about = (function(_super) {
        __extends(_about, _super);

        function _about() {
          return _about.__super__.constructor.apply(this, arguments);
        }

        _about.prototype.template = _.template(Templates.about);

        return _about;

      })(Marionette.ItemView),
      Layout: _Layout = (function(_super) {
        __extends(_Layout, _super);

        function _Layout() {
          return _Layout.__super__.constructor.apply(this, arguments);
        }

        _Layout.prototype.template = _.template(Templates.layout);

        _Layout.prototype.className = "container";

        _Layout.prototype.regions = {
          aboutRegion: "#about-region"
        };

        return _Layout;

      })(Marionette.Layout)
    };
  });

}).call(this);
