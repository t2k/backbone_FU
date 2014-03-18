module.exports =(app, mongoose)->
  Busboy = require "busboy"
  inspect = require("util").inspect
  Grid = require("gridfs-stream")


  app.post "/upload", (req, res) ->
    gfs = new Grid(mongoose.connection.db, mongoose.mongo)
    #console.log "POST: /upload"
    #console.log inspect(mongoose.connection.db)
    busboy = new Busboy
      headers: req.headers
      limits:
        fileSize: 1024 * 1024 * 100 # 2MB
        files: 1 # MAX FILES
    #console.log "busboy created..."


    busboy.on "file", (fieldname, stream, filename, encoding, mimetype) ->
      #console.log "bb-file-event [" + fieldname + "]: filename: " + filename + ", encoding: " + encoding

      writestream = gfs.createWriteStream
        #mode: "w"
        filename: filename
        content_type: mimetype

      writestream.on "close", (file) ->  #
        console.log "writestream-close"
        res.json 201,
          file: file
       

      stream.pipe writestream


    busboy.on "finish", -> # returns async
      console.log "busboy-finish"

    busboy.on "error", -> # returns async
      console.log "busboy-error"


    req.pipe busboy
