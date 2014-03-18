module.exports = function(app, mongoose) {
  var Busboy, Grid, inspect;
  Busboy = require("busboy");
  inspect = require("util").inspect;
  Grid = require("gridfs-stream");
  return app.post("/upload", function(req, res) {
    var busboy, gfs;
    gfs = new Grid(mongoose.connection.db, mongoose.mongo);
    busboy = new Busboy({
      headers: req.headers,
      limits: {
        fileSize: 1024 * 1024 * 100,
        files: 1
      }
    });
    busboy.on("file", function(fieldname, stream, filename, encoding, mimetype) {
      var writestream;
      writestream = gfs.createWriteStream({
        filename: filename,
        content_type: mimetype
      });
      writestream.on("close", function(file) {
        console.log("writestream-close");
        return res.json(201, {
          file: file
        });
      });
      return stream.pipe(writestream);
    });
    busboy.on("finish", function() {
      return console.log("busboy-finish");
    });
    busboy.on("error", function() {
      return console.log("busboy-error");
    });
    return req.pipe(busboy);
  });
};
