# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_TathamOddie.Longitude_session',
  :secret      => '30bddc9b83c06078a242cb1fb304cddbf9f18ac418390ed1e9468e1f8017098ea6af999ee273494b1108a341383e87bc9d2138eb7b785e0ccfb014910b6797ea'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
