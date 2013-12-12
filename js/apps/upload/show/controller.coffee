# file upload controller: require fileupload entities and the ifacelog/app
define ["msgbus", "apps/upload/show/views", "controller/_base", "entities/fileupload"], (msgBus, Views, AppController) ->

    class Controller extends AppController
        initialize: (options)->
            #{region,settings} = options
            @fuOptions = msgBus.reqres.request  "fu:options"

            @layout = @getLayoutView()
            @listenTo @layout, "show", =>
                @titleRegion()
                @optionsRegion
                #@uploadRegion @fuEntities

            @show @layout

        titleRegion: ->
            view = @getTitleView()
            @layout.titleRegion.show view

        optionsRegion:(model) ->
            view = @getOptionsView model
            @layout.optionsRegion.show view

        uploadRegion: (collection) ->
            view = @getUploadView collection

            @listenTo view, "itemview:fu:show", (child, args) ->  # listen to events from itemview (we've overridden the eventnamePrefix to childview)
                msgBus.commands.execute "comp:fu:show", @layout.uploadRegion, args.options

            @layout.uploadRegion.show view


        getTitleView:->
            new Views.Title

        getOptionsView: (model)->
            new Views.Options
                model: model

        getUploadView: (collection)->
            new Views.UploadView
                collection: collection

        getLayoutView: ->
            new Views.Layout