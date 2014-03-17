# upload show app  preset a UI to test file uploads
define ["msgbus", "marionette", "apps/about/show/controller"], (msgBus, Marionette, Controller) ->
    class Router extends Marionette.AppRouter
        appRoutes:
            "about": "show"

    API =
        show: ->
            new Controller

    msgBus.commands.setHandler "start:about:app", ->
        new Router
            controller: API