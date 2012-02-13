# -------------------------------------
# Staging env deploy file
# -------------------------------------
set :application, "staging.tweasier.com"

set :branch,     "staging"
set :deploy_to,  "/home/#{user}/sites/#{application}/"
set :host, "staging.tweasier.com"
