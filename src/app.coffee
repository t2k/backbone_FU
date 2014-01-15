http = require "http"
express = require "express"
util = require 'util'

app = express()
app.use express.static "./public"

app.use app.router
app.set 'view engine', 'jade'
app.set 'views', './views'

app.use express.responseTime()
app.use express.json()
app.use express.urlencoded()

#step 2: use a different multipart parser

#app.use require('connect-multipart')
#    keepExtensions: true
#    uploadDir: "./tempUploads"


app.get "/", (req,res)->
    res.render 'index'

app.get "/upload", (req,res)->
    res.send "<h1>Upload!</h1>"

app.post "/upload", (req,res)->
    multiparty = require 'multiparty'
    form = new multiparty.Form()
    form.parse req, (err, fields, files) ->
      res.writeHead 200,
        "content-type": "text/plain"

      res.write "received upload:\n\n"
      res.end util.inspect(
        fields: fields
        files: files
      )

    return




http.createServer(app).listen process.env.PORT, ->
    console.log 'App Started'

