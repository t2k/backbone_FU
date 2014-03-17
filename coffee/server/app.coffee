express = require "express"

#uploadhandler = require "./uploader"
app = express()





app.configure 'development', ->
  console.log "DEVELOPMENT"
  app.use express.static "./build"

app.configure 'production', ->
  console.log "PRODUCTION"
  app.use express.static "./public"
  app.use express.errorHandler
    dumpExceptions: false, showStack: false

app.use express.multipart
  defer: true
app.use express.logger()
app.set 'view engine', 'jade'
app.set 'views', './views'
app.set 'port', process.env.PORT or 3000
#app.use express.responseTime()
#app.use express.json()
#app.use express.urlencoded()

#app.use app.router

app.use express.errorHandler
  dumpExceptions: true, showStack: true

# INDEX ROUTE, render a JADE view
app.get "/", (req,res)->
  console.log "index route"
  res.render 'index'

app.get "/upload", (req,res)->
  console.log "POST: Upload route"
  res.render 'index'

app.post "/upload", (req,res)->
  console.log "POST: Upload"
  res.render 'index'

app.listen app.get('port'), ->
  console.log "FU Express server listening on port# #{process.env.PORT} Environment #{process.env.NODE_ENV}"

module.exports = app
