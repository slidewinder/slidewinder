# 
# machineId =
#   n = require("os").networkInterfaces()
#   x = {}
#
#   Object.keys(n).filter (v) ->
#     !n[v].forEach (v) ->
#       v.mac.substr(0, v.mac.indexOf(":")) !== "00" && (x[v.mac] = 1)
#   Object.keys(x)
#
#
#
# ().split(":").filter(function(v) {
#         return v !== "00"
# }).join("").substr(0, 15);
