Busboy = require "busboy"

module.exports = (req, res) ->
  cntProcessingFiles = 0
  # use pause stream to have time to open the GridStore

  # do something with the gridfile

  # form error (ie fileupload-cancel)

  # all uploades finished
  end = ->
    # wait until all files are finished
    if cntProcessingFiles > 0
      setTimeout end, 200
      return
    return  if res.finished
    res.send "all done"
    return

  busboy = new Busboy(headers: req.headers)
  busboy.on "file", (fieldname, stream, filename, encoding, contentType) ->
    pStream = pauseStream()
    stream.pipe pStream.pause()
    console.log "POST " + req.originalUrl + " File: " + filename + " Field: " + fieldname
    cntProcessingFiles++
    new GridStore(db, null, filename, "w",
      content_type: contentType
    ).open (err, gridFile) ->
      console.log err  if err
      gridFile.on "close", ->
        gridFile.close (err, data) ->
          cntProcessingFiles--
          return
      pStream.pipe gridFile
      pStream.resume()


  busboy.on "error", (err) ->
    console.error err
    res.send 500, "ERROR", err

  busboy.on "end", end

  # start parsing the HTTP-POST upload
  req.pipe busboy
