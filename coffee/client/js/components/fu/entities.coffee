# component entities: FILE UPLOAD
#    defaults:
#       currentUploadedFileId: 0
#       action: "none"
#       handler: "/upload"
#       queueSizeLimit: 1
#       fileDataName: "fileData"
#       maxFileSize: 1024*1000
#       maxTotalSize: 1024*1000
#       mimeTypes: "image/png, image/jpg"#

define ["backbone", "msgbus"], (Backbone, msgBus ) ->
    class FUOptions extends Backbone.Model  #file upload options
        defaults:
            currentUploadedFileId: 0
            action: "NA"
            handler: "/upload"
            queueSizeLimit:1
            fileDataName: "fileData"
            maxFileSize: 1024*1000*100 # 100MB
            maxTotalFileSize: 1024*1000*100 #100MB
            mimeTypes: ""  # empty string: default behavior ALL FILES ALLOWED

    class FileModel extends Backbone.Model
        sync: (method, model, options) ->
            progress = (e) ->
                progressObj = {}
                progressObj.lengthComputable = e.lengthComputable
                progressObj.loaded = e.loaded
                progressObj.position = e.position
                progressObj.total = e.total
                progressObj.totalSize = e.totalSize
                model.trigger "fu:progress", progressObj

            newOptions = _.defaults(
                xhr: ->
                    xhr = $.ajaxSettings.xhr()
                    xhr.addEventListener "progress", progress, false  if xhr instanceof window.XMLHttpRequest
                    xhr.upload.addEventListener "progress", progress, false  if xhr.upload
                    xhr
                , options)
            Backbone.sync.call @, method, model, newOptions


    class FileEntities extends Backbone.Collection
        model: FileModel
        initialize: (models, options={})->
            @settings = _.extend(
                currentUploadedFileId: 0
                action: "NA"
                handler: "/upload"
                queueSizeLimit: 1
                fileDataName: "fileData"
                maxFileSize: 1024*1000*100
                maxTotalSize: 1024*1000*100
                mimeTypes: ""
                , options)

            @mimeTypes = @settings.mimeTypes.split(",")
            @url = @settings.handler  # collections url for save/post


            msgBus.reqres.setHandler "fu:addToQueue", (input) =>
                @addFile input

            msgBus.reqres.setHandler "fu:queue:empty", =>
                @reset()

            msgBus.reqres.setHandler "fu:queue:upload", =>
                @uploadFiles()

        addFile: (input)->
            i = 0
            while i < input.files.length
                selectedFile = input.files[i]
                if @enforceQueueLimits(selectedFile)
                    _file = new FileModel @settings
                    _file.set "file", selectedFile
                    _file.set "lastModifiedDate", selectedFile.lastModifiedDate
                    _file.set "status", 0
                    _file.set "fileName", selectedFile.name
                    _file.set "mimeType", selectedFile.type
                    _file.set "size", selectedFile.size
                    @add _file
                i++

        uploadFiles: ->
            @each (model) =>
                if model.get("status") is 0 # queued and ready
                    fd = new FormData() #html5 can test for this
                    fd.append "action", @settings.action # can be used on server side to call specific processing/action
                    fd.append "fileId", model.get("cid")
                    fd.append @settings.fileDataName, model.get("file")    #fileToUpload.file
                    model.set "status", 1
                    model.save null,
                        data: fd,
                        contentType: false
                        processData: false

        trimString: (inputString) ->
            inputString.replace /^\s+|\s+$/g, ""

        # goes over the queue and calculates total size
        fileSizeTotal: =>
            @reduce (memo, model)->
                memo + Number model.get "size"
            ,0


        # enforceQueueLimits function
        #  verify queue limit,
        #  verify file size
        #  verify max queue size
        #  verify file is not already added - avoid duplicates
        #  maybe file type rule here ?
        enforceQueueLimits: (file) ->
            errObj = {}
            errObj.file = file
            if @length >= @settings.queueSizeLimit             # verify queue length
                errObj.reason = "Queue is full"
                msgBus.events.trigger "fu:errorAddingFile", errObj
                return false

            if file.size > @settings.maxFileSize              # verify file size
                errObj.reason = "File size exceeded"
                msgBus.events.trigger "fu:errorAddingFile", errObj
                return false

            unless @mimeTypes.length is 0 #verify mime types
                mimeTypeFound = false
                fileMimeType = file.type
                i = 0

                while i < @mimeTypes.length
                    if @trimString(@mimeTypes[i]) is fileMimeType
                        mimeTypeFound = true
                        break
                    i++

                unless mimeTypeFound
                    errObj.reason = "File type not allowed #{fileMimeType}"
                    msgBus.events.trigger "fu:errorAddingFile", errObj
                    return false

            # verify total size
            if @fileSizeTotal + file.size > @settings.maxTotalSize
                errObj.reason = "Total file size exceeded"
                msgBus.events.trigger "fu:errorAddingFile", errObj
                return false

            if @length > 0 #check for duplicates
                added = @findWhere
                    size: file.size
                    fileName: file.name
                if added isnt undefined
                    errObj.reason = "File already added to queue"
                    msgBus.events.trigger "fu:errorAddingFile", errObj
                    return false
            true

    API =
        newFUEntities: (options)->
            new FileEntities [], options

        newFUOptions:->
            new FUOptions


    msgBus.reqres.setHandler "fu:entities", (options) ->
        API.newFUEntities options

    msgBus.reqres.setHandler "new:fuoptions:entity",  ->
        API.newFUOptions()