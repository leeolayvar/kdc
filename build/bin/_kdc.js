(function() {
  var coffee, compileDebug, fs, os, path, pistachios;

  fs = require("fs");

  os = require("os");

  coffee = require("coffee-script");

  path = require("path");

  if (fs.existsSync == null) {
    fs.existsSync = path.existsSync;
  }

  pistachios = /\{(\w*)?(\#\w*)?((?:\.\w*)*)(\[(?:\b\w*\b)(?:\=[\"|\']?.*[\"|\']?)\])*\{([^{}]*)\}\s*\}/g;

  compileDebug = function(path, source, error) {
    var curr, data, first_column, first_line, i, last_column, last_line, lines, next, next_line, point, prev, previous_line, spaces, trace, _i, _ref;
    data = source.toString();
    if (error.location) {
      _ref = error.location, first_line = _ref.first_line, last_line = _ref.last_line, first_column = _ref.first_column, last_column = _ref.last_column;
      lines = data.split(os.EOL);
      trace = lines.slice(first_line, last_line + 1).join(os.EOL);
      point = "";
      for (i = _i = 0; 0 <= last_column ? _i <= last_column : _i >= last_column; i = 0 <= last_column ? ++_i : --_i) {
        if (i < first_column) {
          point += " ";
        } else {
          point += "^";
        }
      }
      point += " " + error.message;
    }
    first_line++;
    last_line++;
    spaces = Array((first_line + "").length + 1).join(" ");
    curr = first_line;
    prev = first_line - 1;
    next = first_line + 1;
    previous_line = first_line > 1 ? "" + prev + "   " + lines[prev - 1] : "";
    next_line = lines.length > next ? "" + next + "  " + lines[next - 1] : "";
    return "at " + path + " line " + first_line + ":" + last_line + " column " + first_column + ":" + last_column + "\n\n" + previous_line + "\n" + curr + "   " + trace + "\n" + spaces + "   " + point + "\n" + next_line;
  };

  module.exports = function() {
    var appPath, bin, block, compiled, data, error, file, files, mainSource, manifest, manifestPath, source, _i, _len, _ref, _ref1, _ref2, _ref3;
    _ref = process.argv, bin = _ref[0], file = _ref[1], appPath = _ref[2];
    appPath || (appPath = process.cwd());
    manifestPath = "" + (path.resolve(appPath)) + "/manifest.json";
    try {
      manifest = JSON.parse(fs.readFileSync(path.join(appPath, "manifest.json")));
    } catch (_error) {
      error = _error;
      if (error.errno === 34) {
        console.log("Manifest file does not exists: " + manifestPath);
      } else {
        console.log("Manifest file seems corrupted: " + manifestPath);
      }
      process.exit(error.errno || 3);
    }
    files = manifest != null ? (_ref1 = manifest.source) != null ? (_ref2 = _ref1.blocks) != null ? (_ref3 = _ref2.app) != null ? _ref3.files : void 0 : void 0 : void 0 : void 0;
    if (!files) {
      console.log("The object 'source.blocks.app.files' is not found in manifest file.");
      process.exit(3);
    }
    if (!Array.isArray(files)) {
      console.log("The object 'source.blocks.app.files' must be array in manifest file.");
      process.exit(3);
    }
    source = "";
    for (_i = 0, _len = files.length; _i < _len; _i++) {
      file = files[_i];
      if (appPath) {
        file = path.normalize(path.join(appPath, file));
      }
      if (/\.coffee/.test(file)) {
        if (fs.existsSync(file)) {
          data = fs.readFileSync(file);
        } else {
          console.log("The required file not found: " + file);
          process.exit(34);
        }
        try {
          compiled = coffee.compile(data.toString(), {
            bare: true
          });
        } catch (_error) {
          error = _error;
          console.log("Compile Error: " + error.message);
          console.log(compileDebug(file, data, error));
          process.exit(4);
        }
      } else if (/\.js/.test(file)) {
        if (fs.existsSync(file)) {
          compiled = fs.readFileSync(file).toString();
        } else {
          console.log("The required file not found: " + file);
          process.exit(34);
        }
      }
      block = "/* BLOCK STARTS: " + file + " */\n" + compiled;
      block = block.replace(pistachios, function(pistachio) {
        return pistachio.replace(/\@/g, 'this.');
      });
      source += block;
    }
    mainSource = "/* Compiled by kdc on " + ((new Date()).toString()) + " */\n(function() {\n/* KDAPP STARTS */\n" + source + "\n/* KDAPP ENDS */\n}).call();";
    fs.writeFileSync(path.join(appPath, "index.js"), mainSource);
    return console.log("Application has been compiled!");
  };

}).call(this);
