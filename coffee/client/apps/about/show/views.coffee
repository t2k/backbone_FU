# list currency views
define ['msgbus', 'marionette', 'apps/about/show/templates'], (msgBus, Marionette, Templates) ->

    About: class _about extends Marionette.ItemView
        template: _.template(Templates.about)

    Layout: class _Layout extends Marionette.Layout
        template: _.template(Templates.layout)
        className: "container"
        regions:
            aboutRegion: "#about-region"