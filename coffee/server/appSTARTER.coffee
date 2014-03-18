###
Module dependencies.
###
express = require("express")
MongoStore = require("connect-mongo")(express)
flash = require("express-flash")
path = require("path")
mongoose = require("mongoose")
passport = require("passport")
expressValidator = require("express-validator")
connectAssets = require("connect-assets")

###
Load controllers.
###
homeController = require("./controllers/home")
userController = require("./controllers/user")
apiController = require("./controllers/api")
contactController = require("./controllers/contact")

###
API keys + Passport configuration.
###
secrets = require("./config/secrets")
passportConf = require("./config/passport")

###
Create Express server.
###
app = express()

###
Mongoose configuration.
###
mongoose.connect secrets.db
mongoose.connection.on "error", ->
  console.error "✗ MongoDB Connection Error. Please make sure MongoDB is running."
  return


###
Express configuration.
###
hour = 3600000
day = (hour * 24)
month = (day * 30)
app.set "port", process.env.PORT or 3000
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"
app.use connectAssets(
  paths: [
    "public/css"
    "public/js"
  ]
  helperContext: app.locals
)
app.use express.compress()
app.use express.favicon()
app.use express.logger("dev")
app.use express.cookieParser()
app.use express.json()
app.use express.urlencoded()
app.use expressValidator()
app.use express.methodOverride()
app.use express.session(
  secret: secrets.sessionSecret
  store: new MongoStore(
    url: secrets.db
    auto_reconnect: true
  )
)
app.use express.csrf()
app.use passport.initialize()
app.use passport.session()
app.use (req, res, next) ->
  res.locals.user = req.user
  res.locals.token = req.csrfToken()
  res.locals.secrets = secrets
  next()
  return

app.use flash()
app.use express.static(path.join(__dirname, "public"),
  maxAge: month
)
app.use (req, res, next) ->
  
  # Keep track of previous URL
  return next()  if req.method isnt "GET"
  path = req.path.split("/")[1]
  return next()  if /(auth|login|logout|signup)$/.test(path)
  req.session.returnTo = req.path
  next()
  return

app.use app.router
app.use (req, res) ->
  res.status 404
  res.render "404"
  return

app.use express.errorHandler()

###
Application routes.
###
app.get "/", homeController.index
app.get "/login", userController.getLogin
app.post "/login", userController.postLogin
app.get "/logout", userController.logout
app.get "/forgot", userController.getForgot
app.post "/forgot", userController.postForgot
app.get "/reset/:token", userController.getReset
app.post "/reset/:token", userController.postReset
app.get "/signup", userController.getSignup
app.post "/signup", userController.postSignup
app.get "/contact", contactController.getContact
app.post "/contact", contactController.postContact
app.get "/account", passportConf.isAuthenticated, userController.getAccount
app.post "/account/profile", passportConf.isAuthenticated, userController.postUpdateProfile
app.post "/account/password", passportConf.isAuthenticated, userController.postUpdatePassword
app.post "/account/delete", passportConf.isAuthenticated, userController.postDeleteAccount
app.get "/account/unlink/:provider", passportConf.isAuthenticated, userController.getOauthUnlink
app.get "/api", apiController.getApi
app.get "/api/lastfm", apiController.getLastfm
app.get "/api/nyt", apiController.getNewYorkTimes
app.get "/api/aviary", apiController.getAviary
app.get "/api/paypal", apiController.getPayPal
app.get "/api/paypal/success", apiController.getPayPalSuccess
app.get "/api/paypal/cancel", apiController.getPayPalCancel
app.get "/api/steam", apiController.getSteam
app.get "/api/scraping", apiController.getScraping
app.get "/api/twilio", apiController.getTwilio
app.post "/api/twilio", apiController.postTwilio
app.get "/api/clockwork", apiController.getClockwork
app.post "/api/clockwork", apiController.postClockwork
app.get "/api/foursquare", passportConf.isAuthenticated, passportConf.isAuthorized, apiController.getFoursquare
app.get "/api/tumblr", passportConf.isAuthenticated, passportConf.isAuthorized, apiController.getTumblr
app.get "/api/facebook", passportConf.isAuthenticated, passportConf.isAuthorized, apiController.getFacebook
app.get "/api/github", passportConf.isAuthenticated, passportConf.isAuthorized, apiController.getGithub
app.get "/api/twitter", passportConf.isAuthenticated, passportConf.isAuthorized, apiController.getTwitter
app.get "/api/venmo", passportConf.isAuthenticated, passportConf.isAuthorized, apiController.getVenmo
app.post "/api/venmo", passportConf.isAuthenticated, passportConf.isAuthorized, apiController.postVenmo
app.get "/api/linkedin", passportConf.isAuthenticated, passportConf.isAuthorized, apiController.getLinkedin

###
OAuth routes for sign-in.
###
app.get "/auth/facebook", passport.authenticate("facebook",
  scope: [
    "email"
    "user_location"
  ]
)
app.get "/auth/facebook/callback", passport.authenticate("facebook",
  failureRedirect: "/login"
), (req, res) ->
  res.redirect req.session.returnTo or "/"
  return

app.get "/auth/github", passport.authenticate("github")
app.get "/auth/github/callback", passport.authenticate("github",
  failureRedirect: "/login"
), (req, res) ->
  res.redirect req.session.returnTo or "/"
  return

app.get "/auth/google", passport.authenticate("google",
  scope: "profile email"
)
app.get "/auth/google/callback", passport.authenticate("google",
  failureRedirect: "/login"
), (req, res) ->
  res.redirect req.session.returnTo or "/"
  return

app.get "/auth/twitter", passport.authenticate("twitter")
app.get "/auth/twitter/callback", passport.authenticate("twitter",
  failureRedirect: "/login"
), (req, res) ->
  res.redirect req.session.returnTo or "/"
  return

app.get "/auth/linkedin", passport.authenticate("linkedin",
  state: "SOME STATE"
)
app.get "/auth/linkedin/callback", passport.authenticate("linkedin",
  failureRedirect: "/login"
), (req, res) ->
  res.redirect req.session.returnTo or "/"
  return


###
OAuth routes for API examples that require authorization.
###
app.get "/auth/foursquare", passport.authorize("foursquare")
app.get "/auth/foursquare/callback", passport.authorize("foursquare",
  failureRedirect: "/api"
), (req, res) ->
  res.redirect "/api/foursquare"
  return

app.get "/auth/tumblr", passport.authorize("tumblr")
app.get "/auth/tumblr/callback", passport.authorize("tumblr",
  failureRedirect: "/api"
), (req, res) ->
  res.redirect "/api/tumblr"
  return

app.get "/auth/venmo", passport.authorize("venmo",
  scope: "make_payments access_profile access_balance access_email access_phone"
)
app.get "/auth/venmo/callback", passport.authorize("venmo",
  failureRedirect: "/api"
), (req, res) ->
  res.redirect "/api/venmo"
  return


###
Start Express server.
###
app.listen app.get("port"), ->
  console.log "✔ Express server listening on port %d in %s mode", app.get("port"), app.settings.env
  return

module.exports = app