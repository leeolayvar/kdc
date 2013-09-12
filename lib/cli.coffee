# 
# # CLI
#
# Our tiny cli api.
# 
fs    = require 'fs'
path  = require 'path'
kdc   = require './_kdc'



# ## Exec
#
# Our main executable code. Note that we are only *adding* functionality to
# KDC calls. If there is an error that doesn't explicitly involve our
# additions, we pass it through to kdc and let kdc print the normal errors.
# We only add functionality, not replace.
exports.exec = ->
  appPath = process.argv[2]
  
  # If no appPath, let kdc throw it.
  if not appPath? then return kdc()

  # Load the manifest. If there is an error, let KDC throw it.
  try
    manifest = fs.readFileSync path.join appPath, 'manifest.json'
    manifest = JSON.parse manifest
  catch err
    return kdc()

  if manifest.devDeps?
    throw new Error 'Not Implemented'
  else
    # Now we get to call KDC, to let it do it's thing normally.
    kdc()

  # KDC throws process exit errors on everything. So, if this code is still
  # running, kdc succeeded and we can continue with our runtime deps
  # injection.
