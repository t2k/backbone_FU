(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'apps/header/list/templates', 'bootstrap'], function(Marionette, Templates) {
    var ListHeaders, _itemview;
    _itemview = (function(_super) {
      __extends(_itemview, _super);

      function _itemview() {
        return _itemview.__super__.constructor.apply(this, arguments);
      }

      _itemview.prototype.template = _.template(Templates.itemview);

      _itemview.prototype.tagName = "li";

      _itemview.prototype.ui = {
        anchor: "a"
      };

      _itemview.prototype.onShow = function() {
        return this.ui.anchor.tooltip();
      };

      return _itemview;

    })(Marionette.ItemView);
    return {
      ListView: ListHeaders = (function(_super) {
        __extends(ListHeaders, _super);

        function ListHeaders() {
          return ListHeaders.__super__.constructor.apply(this, arguments);
        }

        ListHeaders.prototype.template = _.template(Templates.view);

        ListHeaders.prototype.itemView = _itemview;

        ListHeaders.prototype.itemViewContainer = "ul#menulist";

        return ListHeaders;

      })(Marionette.CompositeView)
    };
  });

}).call(this);
