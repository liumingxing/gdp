# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_gdp_session',
  :secret      => '5a79df16fc1c5b030d47bea4c2cef900c0247815a1b96be1ba6272a29f00606686ed6974fb19264580a7fcb9cf9b802684b08b39f3b569ced121ef1226961394'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
