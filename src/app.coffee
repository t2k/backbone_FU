http = require "http"
express = require "express"
util = require 'util'

app = express()
app.use express.static "./public"

app.use app.router
app.set 'view engine', 'jade'
app.set 'views', './views'

app.use express.responseTime()
#app.use express.json()
#app.use express.urlencoded()


# INDEX ROUTE, render a JADE view
app.get "/", (req,res)->
    res.render 'index'

app.get "/upload", (req,res)->
    res.send "<h1>Upload!</h1>"

app.post "/upload", (req,res)->
    multiparty = require 'multiparty'
    form = new multiparty.Form
        autoFiles: true
        uploadDir: "./tempUploads"
        
    form.parse req, (err, fields, files) ->
        if err
            res.writeHead 500,
                "content-type": "text/plain"
            res.send "ERROR: uploading\n\n"

        console.log "upload handled", fields, files
        res.json util.inspect(
            message: "upload complete"
            fields: fields
            files: files
        )
http.createServer(app).listen process.env.PORT, ->
    console.log 'Started: FU serverApp'

