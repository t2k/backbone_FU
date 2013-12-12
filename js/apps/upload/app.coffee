# upload show app  preset a UI to test file uploads
define ["msgbus", "marionette", "apps/upload/show/controller", "components/fu/app"], (msgBus, Marionette, Controller) ->
    class Router extends Marionette.AppRouter
        appRoutes:
            "upload": "show"

    API =
        show: ->
            new Controller


    msgBus.commands.setHandler "start:upload:app", ->
        console.log "starting upload app"
        new Router
            controller: API