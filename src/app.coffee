http = require "http"
express = require "express"
app = express()
app.use express.static "./public"

app.use app.router
app.set 'view engine', 'jade'
app.set 'views', './views'

app.use express.responseTime()

app.use express.bodyParser
    keepExtensions: true
    uploadDir: "./tempUploads"

app.get "/", (req,res)->
    res.render 'index'

app.get "/upload", (req,res)->
    res.send "<h1>Upload!</h1>"

app.post "/upload", (req,res)->
    console.log req
    console.log req.files

    #req.files.forEach (file) ->
    ##    console.log "NAME", file.name
    #    console.log "SIZE", file.size
    #    console.log "PATH", file.path
    #    console.log "TYPE", file.type


http.createServer(app).listen process.env.PORT, ->
    console.log 'App Started'

