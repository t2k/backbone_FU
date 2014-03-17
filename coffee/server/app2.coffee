multiparty = require("multiparty")
http = require("http")
util = require("util")

# parse a file upload

# show a file upload form
http.createServer((req, res) ->
  console.log "REQUEST", req

  if req.url is "/upload" and req.method is "POST"
    console.log "post upload route"
    multiparty = require 'multiparty'
    form = new multiparty.Form
      autoFiles: true
      uploadDir: "./uploads"

    form.parse req, (err, fields, files) ->
      if err
        res.writeHead 500,
            "content-type": "text/plain"
        res.send "ERROR: uploading\n\n"

      res.json util.inspect
        message: "upload complete"
        fields: fields
        files: files

  res.writeHead 200,
    "content-type": "text/html"

  res.end "<form action=\"/upload\" enctype=\"multipart/form-data\" method=\"post\">" + "<input type=\"text\" name=\"title\"><br>" + "<input type=\"file\" name=\"upload\" multiple=\"multiple\"><br>" + "<input type=\"submit\" value=\"Upload\">" + "</form>"

).listen process.env.PORT
console.log "App2 Started..."