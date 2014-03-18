module.exports =
  #db: process.env.MONGODB or "mongodb://localhost:27017/test"
  #db: process.env.MONGODB or "mongodb://localhost/test"
  db: 'mongodb://t2k:t2kmongo1@widmore.mongohq.com:10000/t2kDB' #azure web service
  #db: 'mongodb://t2k:t2kmongo1@linus.mongohq.com:10062/t2k'  #mongoHQ cloud service
  sessionSecret: process.env.SESSION_SECRET or "Your Session Secret goes here"
  localAuth: true
  mailgun:
    login: process.env.MAILGUN_LOGIN or "Your Mailgun SMTP Username"
    password: process.env.MAILGUN_PASSWORD or "Your Mailgun SMTP Password"

  sendgrid:
    user: process.env.SENDGRID_USER or "Your SendGrid Username"
    password: process.env.SENDGRID_PASSWORD or "Your SendGrid Password"

  nyt:
    key: process.env.NYT_KEY or "Your New York Times API Key"

  lastfm:
    api_key: process.env.LASTFM_KEY or "Your API Key"
    secret: process.env.LASTFM_SECRET or "Your API Secret"

  facebookAuth: true
  facebook:
    clientID: process.env.FACEBOOK_ID or "Your App ID"
    clientSecret: process.env.FACEBOOK_SECRET or "Your App Secret"
    callbackURL: "/auth/facebook/callback"
    passReqToCallback: true

  githubAuth: true
  github:
    clientID: process.env.GITHUB_ID or "Your Client ID"
    clientSecret: process.env.GITHUB_SECRET or "Your Client Secret"
    callbackURL: "/auth/github/callback"
    passReqToCallback: true

  twitterAuth: true
  twitter:
    consumerKey: process.env.TWITTER_KEY or "Your Consumer Key"
    consumerSecret: process.env.TWITTER_SECRET or "Your Consumer Secret"
    callbackURL: "/auth/twitter/callback"
    passReqToCallback: true

  googleAuth: true
  google:
    clientID: process.env.GOOGLE_ID or "Your Client ID"
    clientSecret: process.env.GOOGLE_SECRET or "Your Client Secret"
    callbackURL: "/auth/google/callback"
    passReqToCallback: true

  linkedinAuth: true
  linkedin:
    clientID: process.env.LINKEDIN_ID or "Your Client ID"
    clientSecret: process.env.LINKEDIN_SECRET or "Your Client Secret"
    callbackURL: "/auth/linkedin/callback"
    scope: [
      "r_fullprofile"
      "r_emailaddress"
      "r_network"
    ]
    passReqToCallback: true

  steam:
    apiKey: process.env.STEAM_KEY or "Your Steam API Key"

  twilio:
    sid: process.env.TWILIO_SID or "Your Twilio SID"
    token: process.env.TWILIO_TOKEN or "Your Twilio token"

  clockwork:
    apiKey: process.env.CLOCKWORK_KEY or "Your Clockwork SMS API Key"

  tumblr:
    consumerKey: process.env.TUMBLR_KEY or "Your Consumer Key"
    consumerSecret: process.env.TUMBLR_SECRET or "Your Consumer Secret"
    callbackURL: "/auth/tumblr/callback"

  foursquare:
    clientId: process.env.FOURSQUARE_ID or "Your Client ID"
    clientSecret: process.env.FOURSQUARE_SECRET or "Your Client Secret"
    redirectUrl: process.env.FOURSQUARE_REDIRECT_URL or "http://localhost:3000/auth/foursquare/callback"

  venmo:
    clientId: process.env.VENMO_ID or "Your Venmo Client ID"
    clientSecret: process.env.VENMO_SECRET or "Your Venmo Client Secret"
    redirectUrl: process.env.VENMO_REDIRECT_URL or "http://localhost:3000/auth/venmo/callback"

  paypal:
    host: process.env.PAYPAL_HOST or "api.sandbox.paypal.com"
    client_id: process.env.PAYPAL_ID or "Your Client ID"
    client_secret: process.env.PAYPAL_SECRET or "Your Client Secret"
    returnUrl: process.env.PAYPAL_RETURN_URL or "http://localhost:3000/api/paypal/success"
    cancelUrl: process.env.PAYPAL_CANCEL_URL or "http://localhost:3000/api/paypal/cancel"