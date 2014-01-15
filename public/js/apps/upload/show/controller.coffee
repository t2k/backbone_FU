# file upload controller: require fileupload entities and the ifacelog/app
define ["msgbus", "backbone", "apps/upload/show/views", "controller/_base", "entities/fileupload", "backbone.syphon","components/fu/app"], (msgBus, Backbone, Views, AppController) ->

    class Controller extends AppController
        initialize: ->
            #{region,settings} = options
            model = msgBus.reqres.request  "new:fuoptions:entity"

            @layout = @getLayoutView()
            @listenTo @layout, "show", =>
                @titleRegion()
                @optionsRegion model

            @show @layout

        titleRegion: ->
            view = @getTitleView()
            @layout.titleRegion.show view

        optionsRegion:(model) ->
            view = @getOptionsView model
            @listenTo view, "button:clicked", =>
                data = Backbone.Syphon.serialize view
                msgBus.commands.execute "component:fu:show", @layout.uploadRegion, data

            @layout.optionsRegion.show view

        getTitleView:->
            new Views.Title

        getOptionsView: (model)->
            new Views.Options
                model: model

        getLayoutView: ->
            new Views.Layout