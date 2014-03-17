# fu == file upload
define ["msgbus", "marionette", "components/fu/show/controller"], (msgBus, Marionette, Controller) ->

    API =
        show:(region, options) ->
            new Controller
                region: region
                options: options

    msgBus.commands.setHandler "component:fu:show", (region, options) ->
        console.log "passed-in:", options
        API.show region, options