# file upload controller: require fileupload entities and the ifacelog/app
define ["msgbus", "components/fu/show/views", "controller/_base", "entities/fileupload" ], (msgBus, Views, AppController) ->

    class Controller extends AppController
        initialize: (_options)->
            {region, options} = _options
            @fuEntities = msgBus.reqres.request  "fu:entities", options
            @layout = @getLayoutView()
            @listenTo @layout, "show", =>
                @uploadRegion @fuEntities

            @show @layout

        uploadRegion: (collection) ->
            view = @getUploadView collection

            @listenTo view, "select:file", (input) ->
                msgBus.reqres.request "fu:addToQueue", input

            @listenTo view, "click:upload",  ->
                msgBus.reqres.request "fu:queue:upload"

            @listenTo view, "click:clearall",  ->
                msgBus.reqres.request "fu:queue:empty"

            @layout.uploadRegion.show view

        getUploadView: (collection)->
            new Views.UploadView
                collection: collection

        getLayoutView: ->
            new Views.Layout