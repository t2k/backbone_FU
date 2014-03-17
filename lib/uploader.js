var Busboy;

Busboy = require("busboy");

module.exports = function(req, res) {
  var busboy, cntProcessingFiles, end;
  cntProcessingFiles = 0;
  end = function() {
    if (cntProcessingFiles > 0) {
      setTimeout(end, 200);
      return;
    }
    if (res.finished) {
      return;
    }
    res.send("all done");
  };
  busboy = new Busboy({
    headers: req.headers
  });
  busboy.on("file", function(fieldname, stream, filename, encoding, contentType) {
    var pStream;
    pStream = pauseStream();
    stream.pipe(pStream.pause());
    console.log("POST " + req.originalUrl + " File: " + filename + " Field: " + fieldname);
    cntProcessingFiles++;
    return new GridStore(db, null, filename, "w", {
      content_type: contentType
    }).open(function(err, gridFile) {
      if (err) {
        console.log(err);
      }
      gridFile.on("close", function() {
        return gridFile.close(function(err, data) {
          cntProcessingFiles--;
        });
      });
      pStream.pipe(gridFile);
      return pStream.resume();
    });
  });
  busboy.on("error", function(err) {
    console.error(err);
    return res.send(500, "ERROR", err);
  });
  busboy.on("end", end);
  return req.pipe(busboy);
};
