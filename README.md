##backbone.fu
A Backbone File Upload component.

I've included a client-side webApp so you can have that **FU** experience day or night.

![Screenshot][ss]

[ss]:  https://github.com/t2k/backbone.fu/raw/master/img/fu_component.png "Screen shot: Using the FU Component"

#### install coffee-script and bower globally
```
npm install -g coffee-script bower
```

#### install client side dependencies via bower.json
```
$ bower install
```

#### install node modules via package.json
```
$ npm install
```

#### coffeescript: compile and watch
```
$ coffee -o js/ -cw js/
$ coffee -o lib/ -cw src/
```

##start webApp:
```
$ node lib/app
```


## Using the FU Component
NOTE: the required ```components/fu/app```

```
# upload show controller: require the components/fu/app
define ["msgbus", "backbone", "apps/upload/show/views", "controller/_base", "components/fu/app", "backbone.syphon"], (msgBus, Backbone, Views, AppController) ->

    class Controller extends AppController
        initialize: ->
            #{region,settings} = options
            model = msgBus.reqres.request  "new:fuoptions:entity"

            @layout = @getLayoutView()
            @listenTo @layout, "show", =>
                @titleRegion()
                @optionsRegion model

            @show @layout

        titleRegion: ->
            view = @getTitleView()
            @layout.titleRegion.show view

        optionsRegion:(model) ->
            view = @getOptionsView model
            @listenTo view, "button:clicked", =>
                # using Syphon to grab hash/options from the view's UI
                # 
                data = Backbone.Syphon.serialize view
            
                # this is where the FU component is called...
                # display within this apps 'uploadRegion and pass in options
                # see components/fu/entities
                msgBus.commands.execute "component:fu:show", @layout.uploadRegion, data

            @layout.optionsRegion.show view

        getTitleView:->
            new Views.Title

        getOptionsView: (model)->
            new Views.Options
                model: model

        getLayoutView: ->
            new Views.Layout

```