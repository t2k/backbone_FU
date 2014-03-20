# static header entities
define ["backbone", "msgbus"], (Backbone, msgBus ) ->

    class Header extends Backbone.Model

    class HeaderCollection extends Backbone.Collection
        model: Header

    API =
        getHeaders:->
            new Backbone.Collection [
                (name: "Uploader", url: "#upload", title: "Upload manager", cssClass: "glyphicon glyphicon-hdd")
                (name: "About", url: "#about", title: "What up?", cssClass: "glyphicon glyphicon-dashboard")
                ]

    msgBus.reqres.setHandler "header:entities", ->
        API.getHeaders()
