# 
# # CLI
#
# Our tiny cli api.
# 


# ## Exec
#
# Our main executable code. Note that we are only *adding* functionality to
# KDC calls. If there is an error that doesn't explicitly involve our
# additions, we pass it through to kdc and let kdc print the normal errors.
# We only add functionality, not replace.
exports.exec = (argv) ->
