# file upload controller: require fileupload entities and the ifacelog/app
define ["msgbus", "apps/upload/show/views", "controller/_base", "entities/fileupload"], (msgBus, Views, AppController) ->

    class Controller extends AppController
        initialize: (options)->
            @fuEntities = msgBus.reqres.request  "fu:entities", options

            @layout = @getLayoutView()
            @listenTo @layout, "show", =>
                @titleRegion()
                @uploadRegion @fuEntities

            @show @layout

        titleRegion: ->
            view = @getTitleView()
            @layout.titleRegion.show view

        uploadRegion: (collection) ->
            view = @getUploadView collection

            @listenTo view, "itemview:log:refresh", (child, args) ->  # listen to events from itemview (we've overridden the eventnamePrefix to childview)
                @logRegion()

            @listenTo view, "select:file", (input) ->
                msgBus.reqres.request "fu:addToQueue", input

            @listenTo view, "click:upload",  ->
                msgBus.reqres.request "fu:queue:upload"

            @listenTo view, "click:clearall",  ->
                msgBus.reqres.request "fu:queue:empty"

            @layout.uploadRegion.show view


        getTitleView:->
            new Views.Title


        getUploadView: (collection)->
            new Views.UploadView
                collection: collection

        getLayoutView: ->
            new Views.Layout