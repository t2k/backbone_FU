# file upload controller: require fileupload entities and the ifacelog/app
define ["msgbus", "apps/about/show/views", "controller/_base"], (msgBus, Views, AppController) ->

    class Controller extends AppController
        initialize: ->

            @layout = @getLayoutView()
            @listenTo @layout, "show", =>
                @aboutRegion()
            @show @layout

        aboutRegion: ->
            view = @getAboutView()
            @layout.aboutRegion.show view


        getAboutView:->
            new Views.About

        getLayoutView: ->
            new Views.Layout