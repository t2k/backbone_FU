# list header views
define ['marionette', 'apps/header/list/templates', 'bootstrap' ], (Marionette, Templates) ->

    class _itemview extends Marionette.ItemView
        template: _.template(Templates.itemview)
        tagName: "li"
        ui:
            anchor: "a"

        onShow: ->
            @ui.anchor.tooltip()


    ListView: class ListHeaders extends Marionette.CompositeView
        template: _.template(Templates.view)
        itemView: _itemview
        itemViewContainer: "ul#menulist"