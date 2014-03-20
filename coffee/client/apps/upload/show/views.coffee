# list currency views
define ['msgbus', 'marionette', 'apps/upload/show/templates'], (msgBus, Marionette, Templates) ->

    Title: class _title extends Marionette.ItemView
        template: _.template(Templates.title)

    Options: class _options extends Marionette.ItemView
        template: _.template(Templates.options)
        triggers:
            "click button" : "button:clicked"

    Layout: class _Layout extends Marionette.Layout
        template: _.template(Templates.layout)
        className: "container"
        regions:
            titleRegion: "#title-region"
            optionsRegion: "#options-region"
            uploadRegion: "#upload-region"