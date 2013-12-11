# fu == file upload
define ["msgbus", "marionette", "components/fu/show/controller"], (msgBus, Marionette, Controller) ->


    API =
        show:(region, options) ->
            new Controller
                region: region
                options: options

                # custom attributes overriden for this instance
                # one file max, must be a text/plain, run the ZDCashFlows process
                #action: "none" # this is the process to be run after the file is uploaded/ default noOp is 'upload'
                #mimeTypes: "text/plain"
                #queueSizeLimit: 1
                #fileDataName: "Filedata"
                #handler: "/upload"


    msgBus.commands.setHandler "comp:fu:show", (region, options) ->
        API.list region, options