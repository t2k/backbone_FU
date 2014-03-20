(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(["backbone", "msgbus"], function(Backbone, msgBus) {
    var API, FUOptions, FileEntities, FileModel;
    FUOptions = (function(_super) {
      __extends(FUOptions, _super);

      function FUOptions() {
        return FUOptions.__super__.constructor.apply(this, arguments);
      }

      FUOptions.prototype.defaults = {
        currentUploadedFileId: 0,
        action: "NA",
        handler: "/upload",
        queueSizeLimit: 1,
        fileDataName: "fileData",
        maxFileSize: 1024 * 1000 * 100,
        maxTotalFileSize: 1024 * 1000 * 100,
        mimeTypes: ""
      };

      return FUOptions;

    })(Backbone.Model);
    FileModel = (function(_super) {
      __extends(FileModel, _super);

      function FileModel() {
        return FileModel.__super__.constructor.apply(this, arguments);
      }

      FileModel.prototype.sync = function(method, model, options) {
        var newOptions, progress;
        progress = function(e) {
          var progressObj;
          progressObj = {};
          progressObj.lengthComputable = e.lengthComputable;
          progressObj.loaded = e.loaded;
          progressObj.position = e.position;
          progressObj.total = e.total;
          progressObj.totalSize = e.totalSize;
          return model.trigger("fu:progress", progressObj);
        };
        newOptions = _.defaults({
          xhr: function() {
            var xhr;
            xhr = $.ajaxSettings.xhr();
            if (xhr instanceof window.XMLHttpRequest) {
              xhr.addEventListener("progress", progress, false);
            }
            if (xhr.upload) {
              xhr.upload.addEventListener("progress", progress, false);
            }
            return xhr;
          }
        }, options);
        return Backbone.sync.call(this, method, model, newOptions);
      };

      return FileModel;

    })(Backbone.Model);
    FileEntities = (function(_super) {
      __extends(FileEntities, _super);

      function FileEntities() {
        this.fileSizeTotal = __bind(this.fileSizeTotal, this);
        return FileEntities.__super__.constructor.apply(this, arguments);
      }

      FileEntities.prototype.model = FileModel;

      FileEntities.prototype.initialize = function(models, options) {
        if (options == null) {
          options = {};
        }
        this.settings = _.extend({
          currentUploadedFileId: 0,
          action: "NA",
          handler: "/upload",
          queueSizeLimit: 1,
          fileDataName: "fileData",
          maxFileSize: 1024 * 1000 * 100,
          maxTotalSize: 1024 * 1000 * 100,
          mimeTypes: ""
        }, options);
        this.mimeTypes = this.settings.mimeTypes.split(",");
        this.url = this.settings.handler;
        msgBus.reqres.setHandler("fu:addToQueue", (function(_this) {
          return function(input) {
            return _this.addFile(input);
          };
        })(this));
        msgBus.reqres.setHandler("fu:queue:empty", (function(_this) {
          return function() {
            return _this.reset();
          };
        })(this));
        return msgBus.reqres.setHandler("fu:queue:upload", (function(_this) {
          return function() {
            return _this.uploadFiles();
          };
        })(this));
      };

      FileEntities.prototype.addFile = function(input) {
        var i, selectedFile, _file, _results;
        i = 0;
        _results = [];
        while (i < input.files.length) {
          selectedFile = input.files[i];
          if (this.enforceQueueLimits(selectedFile)) {
            _file = new FileModel(this.settings);
            _file.set("file", selectedFile);
            _file.set("lastModifiedDate", selectedFile.lastModifiedDate);
            _file.set("status", 0);
            _file.set("fileName", selectedFile.name);
            _file.set("mimeType", selectedFile.type);
            _file.set("size", selectedFile.size);
            this.add(_file);
          }
          _results.push(i++);
        }
        return _results;
      };

      FileEntities.prototype.uploadFiles = function() {
        return this.each((function(_this) {
          return function(model) {
            var fd;
            if (model.get("status") === 0) {
              fd = new FormData();
              fd.append("action", _this.settings.action);
              fd.append("fileId", model.get("cid"));
              fd.append(_this.settings.fileDataName, model.get("file"));
              model.set("status", 1);
              return model.save(null, {
                data: fd,
                contentType: false,
                processData: false
              });
            }
          };
        })(this));
      };

      FileEntities.prototype.trimString = function(inputString) {
        return inputString.replace(/^\s+|\s+$/g, "");
      };

      FileEntities.prototype.fileSizeTotal = function() {
        return this.reduce(function(memo, model) {
          return memo + Number(model.get("size"));
        }, 0);
      };

      FileEntities.prototype.enforceQueueLimits = function(file) {
        var added, errObj, fileMimeType, i, mimeTypeFound;
        errObj = {};
        errObj.file = file;
        if (this.length >= this.settings.queueSizeLimit) {
          errObj.reason = "Queue is full";
          msgBus.events.trigger("fu:errorAddingFile", errObj);
          return false;
        }
        if (file.size > this.settings.maxFileSize) {
          errObj.reason = "File size exceeded";
          msgBus.events.trigger("fu:errorAddingFile", errObj);
          return false;
        }
        if (!(this.mimeTypes.length === 0 || this.mimeTypes[0].length === 0)) {
          mimeTypeFound = false;
          fileMimeType = file.type;
          i = 0;
          while (i < this.mimeTypes.length) {
            if (this.trimString(this.mimeTypes[i]) === fileMimeType) {
              mimeTypeFound = true;
              break;
            }
            i++;
          }
          if (!mimeTypeFound) {
            errObj.reason = "File type not allowed " + fileMimeType;
            msgBus.events.trigger("fu:errorAddingFile", errObj);
            return false;
          }
        }
        if (this.fileSizeTotal + file.size > this.settings.maxTotalSize) {
          errObj.reason = "Total file size exceeded";
          msgBus.events.trigger("fu:errorAddingFile", errObj);
          return false;
        }
        if (this.length > 0) {
          added = this.findWhere({
            size: file.size,
            fileName: file.name
          });
          if (added !== void 0) {
            errObj.reason = "File already added to queue";
            msgBus.events.trigger("fu:errorAddingFile", errObj);
            return false;
          }
        }
        return true;
      };

      return FileEntities;

    })(Backbone.Collection);
    API = {
      newFUEntities: function(options) {
        return new FileEntities([], options);
      },
      newFUOptions: function() {
        return new FUOptions;
      }
    };
    msgBus.reqres.setHandler("fu:entities", function(options) {
      return API.newFUEntities(options);
    });
    return msgBus.reqres.setHandler("new:fuoptions:entity", function() {
      return API.newFUOptions();
    });
  });

}).call(this);
