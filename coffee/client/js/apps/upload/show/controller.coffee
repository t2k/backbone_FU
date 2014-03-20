# upload show controller: require the components/fu/app
define ["msgbus", "backbone", "apps/upload/show/views", "controller/_base", "components/fu/app", "backbone.syphon"], (msgBus, Backbone, Views, AppController) ->

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
                # using Syphon to grab hash/options from the view's UI
                # 
                data = Backbone.Syphon.serialize view
            
                # this is where the FU component is called...
                # display within this apps 'uploadRegion and pass in options
                # see components/fu/entities
                msgBus.commands.execute "component:fu:show", @layout.uploadRegion, data

            @layout.optionsRegion.show view

        getTitleView:->
            new Views.Title

        getOptionsView: (model)->
            new Views.Options
                model: model

        getLayoutView: ->
            new Views.Layout