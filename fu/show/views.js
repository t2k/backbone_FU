(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['apps/fu/show/templates', 'views/_base', 'msgbus'], function(Templates, AppView, msgBus) {
    var FUCompositeView, FuEmpty, FuItem, _Layout, _ref, _ref1, _ref2, _ref3, _ref4, _title;

    FuItem = (function(_super) {
      __extends(FuItem, _super);

      function FuItem() {
        _ref = FuItem.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      FuItem.prototype.template = _.template(Templates.fuitem);

      FuItem.prototype.tagName = "li";

      FuItem.prototype.className = "list-group-item";

      FuItem.prototype.ui = {
        status: "#status",
        progress: ".progress",
        progressBar: ".progress-bar"
      };

      FuItem.prototype.events = {
        "click button": function() {
          return this.model.destroy();
        }
      };

      FuItem.prototype.modelEvents = {
        "fu:progress": function(data) {
          if (data.lengthComputable) {
            return this.ui.progressBar.width("" + (Math.ceil(data.loaded / data.total * 100)) + "%");
          }
        },
        "request": function() {
          return this.ui.progress.show();
        },
        "error": function() {
          this.ui.progress.hide();
          this.model.set({
            "status": 3
          });
          return this.ui.status.attr("class", "glyphicon glyphicon-minus-sign");
        },
        "sync": function() {
          this.ui.progress.hide();
          this.model.set({
            "status": 2
          });
          return this.ui.status.attr("class", "glyphicon glyphicon-saved");
        },
        "change:status": function() {
          var state, _class;

          state = this.model.get("status");
          if (state > 1) {
            this.trigger("log:refresh");
          }
          _class = (function() {
            switch (false) {
              case !(state = 0):
                return "glyphicon glyphicon-upload";
              case !(state = 1):
                return "glyphicon glyphicon-cloud-upload";
              case !(state = 2):
                return "glyphicon glyphicon-saved";
              case !(state = 3):
                return "glyphicon glyphicon-minus-sign";
              default:
                return "";
            }
          })();
          console.log("change:status", state, _class);
          return this.ui.status.attr("class", _class);
        }
      };

      return FuItem;

    })(AppView.ItemView);
    FuEmpty = (function(_super) {
      __extends(FuEmpty, _super);

      function FuEmpty() {
        _ref1 = FuEmpty.__super__.constructor.apply(this, arguments);
        return _ref1;
      }

      FuEmpty.prototype.template = _.template(Templates.fuempty);

      FuEmpty.prototype.tagName = "li";

      FuEmpty.prototype.className = "list-group-item";

      return FuEmpty;

    })(AppView.ItemView);
    return {
      UploadView: FUCompositeView = (function(_super) {
        __extends(FUCompositeView, _super);

        function FUCompositeView() {
          _ref2 = FUCompositeView.__super__.constructor.apply(this, arguments);
          return _ref2;
        }

        FUCompositeView.prototype.template = _.template(Templates.fileupload);

        FUCompositeView.prototype.itemView = FuItem;

        FUCompositeView.prototype.emptyView = FuEmpty;

        FUCompositeView.prototype.itemViewContainer = "#filequeue";

        FUCompositeView.prototype.collectionEvents = {
          "reset add remove": function() {
            this.ui.filesize.text(Globalize.format(this.collection.fileSizeTotal(), "n0"));
            return this.ui.filecount.text(this.collection.length);
          }
        };

        FUCompositeView.prototype.ui = {
          filesize: ".filesize",
          filecount: ".filecount",
          alert: ".alert",
          fileInput: "#fileinput",
          browse: "#browse",
          upload: "#upload",
          clearall: "#clearall"
        };

        FUCompositeView.prototype.initialize = function(options) {
          var _this = this;

          if (options == null) {
            options = {};
          }
          return msgBus.events.on("onErrorAddingFile", function(err) {
            _this.ui.alert.find("span").text(err.reason);
            return _this.ui.alert.fadeIn().fadeOut(3000);
          });
        };

        FUCompositeView.prototype.events = {
          "click #browse": function() {
            return this.ui.fileInput.trigger("click");
          },
          "click #clearall": function() {
            return this.trigger("click:clearall");
          },
          "click #upload": function() {
            return this.trigger("click:upload");
          },
          "change #fileinput": function(e) {
            return this.trigger("select:file", e.target);
          }
        };

        return FUCompositeView;

      })(AppView.CompositeView),
      Title: _title = (function(_super) {
        __extends(_title, _super);

        function _title() {
          _ref3 = _title.__super__.constructor.apply(this, arguments);
          return _ref3;
        }

        _title.prototype.template = _.template(Templates.title);

        return _title;

      })(AppView.ItemView),
      Layout: _Layout = (function(_super) {
        __extends(_Layout, _super);

        function _Layout() {
          _ref4 = _Layout.__super__.constructor.apply(this, arguments);
          return _ref4;
        }

        _Layout.prototype.template = _.template(Templates.layout);

        _Layout.prototype.className = "container";

        _Layout.prototype.regions = {
          titleRegion: "#title-region",
          uploadRegion: "#upload-region",
          logRegion: "#log-region"
        };

        return _Layout;

      })(AppView.Layout)
    };
  });

}).call(this);
