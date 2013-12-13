# app startup.
define ["msgbus", "backbone", "apps/load" ], (msgBus, Backbone  ) ->
    app = new Backbone.Marionette.Application()

    app.rootRoute = "upload"

    app.addRegions
        headerRegion: "#header-region"
        mainRegion: "#main-region"
        footerRegion: "#footer-region"

    app.on "initialize:before", (options) ->

    msgBus.reqres.setHandler "default:region",->
        app.mainRegion

    msgBus.reqres.setHandler "header:region", ->
        app.headerRegion

    msgBus.reqres.setHandler "footer:region", ->
        app.footerRegion

    msgBus.commands.setHandler "register:instance", (instance, id) ->
        app.register instance, id

    msgBus.commands.setHandler "unregister:instance", (instance, id) ->
        app.unregister instance, id

    app.on "initialize:after", (options)->
        if Backbone.history
            Backbone.history.start options
            @navigate(@rootRoute, trigger: true) if @getCurrentRoute() is null

    # configure for loading templates that are stored externally...
    app.addInitializer (options) ->
        msgBus.commands.execute "start:header:app"
        msgBus.commands.execute "start:footer:app"
        msgBus.commands.execute "start:upload:app"
        msgBus.commands.execute "start:about:app"

    app