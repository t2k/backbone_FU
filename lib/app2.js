var http, multiparty, util;

multiparty = require("multiparty");

http = require("http");

util = require("util");

http.createServer(function(req, res) {
  var form;
  console.log("REQUEST", req);
  if (req.url === "/upload" && req.method === "POST") {
    console.log("post upload route");
    multiparty = require('multiparty');
    form = new multiparty.Form({
      autoFiles: true,
      uploadDir: "./uploads"
    });
    form.parse(req, function(err, fields, files) {
      if (err) {
        res.writeHead(500, {
          "content-type": "text/plain"
        });
        res.send("ERROR: uploading\n\n");
      }
      return res.json(util.inspect({
        message: "upload complete",
        fields: fields,
        files: files
      }));
    });
  }
  res.writeHead(200, {
    "content-type": "text/html"
  });
  return res.end("<form action=\"/upload\" enctype=\"multipart/form-data\" method=\"post\">" + "<input type=\"text\" name=\"title\"><br>" + "<input type=\"file\" name=\"upload\" multiple=\"multiple\"><br>" + "<input type=\"submit\" value=\"Upload\">" + "</form>");
}).listen(process.env.PORT);

console.log("App2 Started...");
