# file upload controller: require fileupload entities and the ifacelog/app
define ["msgbus", "apps/upload/show/views", "controller/_base", "entities/fileupload"], (msgBus, Views, AppController) ->

    class Controller extends AppController
        initialize: ->
            #{region,settings} = options
            fuOptModel = msgBus.reqres.request  "new:fuoptions:entity"
            console.log fuOptModel

            @layout = @getLayoutView()
            @listenTo @layout, "show", =>
                @titleRegion()
                @optionsRegion fuOptModel
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

            @listenTo view, "itemview:fu:show", (child, args) ->
                msgBus.commands.execute "comp:fu:show", @layout.uploadRegion, args.model

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