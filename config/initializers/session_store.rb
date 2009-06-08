# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_recommender_session',
  :secret      => '8fc6923a067b34e83ff93ce767127d947ff229b00d90d565a72ae1782c93e75edb2ac77364211d2a84b10361357eb41d462b01d3ddf2a0479bb5826f66222df7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
