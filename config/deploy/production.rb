# -------------------------------------
# Production env deploy file
# -------------------------------------
set :application, "tweasier.com"

set :branch,     "master" #0.9.9
set :deploy_to,  "/home/#{user}/sites/#{application}/"
set :host, "tweasier.com"
