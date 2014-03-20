# header list controller
define ["msgbus","apps/header/list/views", "controller/_base", "entities/header"], (msgBus, View, AppController) ->
    class Controller extends AppController
        initialize: ->
            links = msgBus.reqres.request "header:entities"
            headerView = @getHeaderView links

            @show headerView
            #msgBus.events.trigger "list:header", headerView

        getHeaderView:(links)->
            new View.ListView
                collection: links