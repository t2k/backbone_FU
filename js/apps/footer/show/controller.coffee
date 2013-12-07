# footer_app controller
define ["msgbus","apps/footer/show/views", "controller/_base"], (msgBus, Views, AppController) ->

    class Controller extends AppController
        initialize:->
            footerView = @getFooterView()
            @show footerView

        getFooterView:  ->
            new Views.ItemView
