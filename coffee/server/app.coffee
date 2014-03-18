###
module dependencies
###
express = require "express"
mongoose = require "mongoose"

###
API keys + Passport configuration.
###
secrets = require("./config/secrets")


###
create express server
###
app = express()

###
Mongoose configuration.
###
mongoose.connect secrets.db
mongoose.connection.on "error", ->
  console.error "✗ MongoDB Connection Error. Please make sure MongoDB is running."
  return

app.configure 'development', ->
  console.log "DEVELOPMENT"
  app.use express.static "./build"
  app.use express.errorHandler
    dumpExceptions: true, showStack: true

app.configure 'production', ->
  console.log "PRODUCTION"
  app.use express.static "./public"
  app.use express.errorHandler
    dumpExceptions: false, showStack: false

app.use express.logger()

uploadhandler = require("./uploader")(app, mongoose)

app.set 'view engine', 'jade'
app.set 'views', './views'
app.set 'port', process.env.PORT or 3000
app.set 'env', process.env.ENV or "development"
app.use express.responseTime()
app.use express.json()
app.use express.urlencoded()
app.use app.router


# INDEX ROUTE, render a JADE view
app.get "/", (req,res)->
  console.log "index route"
  res.render 'index'

app.listen app.get('port'), ->
  console.log "Express server listening on port# #{app.get('port')} running in #{app.get('env')} environment"

module.exports = app
