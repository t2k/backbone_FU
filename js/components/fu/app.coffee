# fu == file upload
define ["msgbus", "marionette", "components/fu/show/controller"], (msgBus, Marionette, Controller) ->


    API =
        show:(region, options) ->
            new Controller
                region: region
                options: options

    msgBus.commands.setHandler "comp:fu:show", (region, options) ->
        API.show region, options