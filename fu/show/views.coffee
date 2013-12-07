# list currency views
define ['apps/fu/show/templates', 'views/_base', 'msgbus'], (Templates, AppView, msgBus) ->

    class FuItem extends AppView.ItemView
        template: _.template(Templates.fuitem)
        tagName: "li"
        className: "list-group-item"

        ui:
            status: "#status"
            progress: ".progress"
            progressBar: ".progress-bar"
        events:
            "click button": ->
                @model.destroy()

        modelEvents:
            "fu:progress": (data)->
                @ui.progressBar.width "#{Math.ceil(data.loaded/data.total*100)}%" if data.lengthComputable

            "request": ->
                @ui.progress.show()

            "error":->
                @ui.progress.hide()
                @model.set "status": 3
                @ui.status.attr("class", "glyphicon glyphicon-minus-sign")


            "sync" : ->
                @ui.progress.hide()
                @model.set "status":2
                @ui.status.attr("class", "glyphicon glyphicon-saved")

            "change:status": ->
                state = @model.get "status"
                @trigger "log:refresh" if state > 1
                _class = switch
                    when state=0 then "glyphicon glyphicon-upload"
                    when state=1 then "glyphicon glyphicon-cloud-upload"
                    when state=2 then "glyphicon glyphicon-saved"
                    when state=3 then "glyphicon glyphicon-minus-sign"
                    else ""
                console.log "change:status", state, _class
                @ui.status.attr("class", _class)

    class FuEmpty extends AppView.ItemView
        template: _.template(Templates.fuempty)
        tagName: "li"
        className: "list-group-item"


    UploadView: class FUCompositeView extends AppView.CompositeView
        template: _.template(Templates.fileupload)
        itemView: FuItem
        emptyView: FuEmpty
        itemViewContainer: "#filequeue"
        collectionEvents:
            "reset add remove": ->
                @ui.filesize.text Globalize.format @collection.fileSizeTotal(),"n0"
                @ui.filecount.text @collection.length


        ui:
            filesize:       ".filesize"
            filecount:      ".filecount"
            alert:          ".alert"
            fileInput:      "#fileinput"
            browse:         "#browse"
            upload:         "#upload"
            clearall:       "#clearall"

        initialize: (options={})->
            msgBus.events.on "onErrorAddingFile", (err) =>
                @ui.alert.find("span").text(err.reason)
                @ui.alert.fadeIn().fadeOut(3000)

        events:
            "click #browse": ->
                @ui.fileInput.trigger "click"

            "click #clearall": ->
                @trigger "click:clearall"

            "click #upload": ->
                @trigger "click:upload"

            "change #fileinput": (e)->
                @trigger "select:file", e.target  # send the DOM element


    Title: class _title extends AppView.ItemView
        template: _.template(Templates.title)


    Layout: class _Layout extends AppView.Layout
        template: _.template(Templates.layout)
        className: "container"
        regions:
            titleRegion: "#title-region"
            uploadRegion: "#upload-region"
            logRegion: "#log-region"