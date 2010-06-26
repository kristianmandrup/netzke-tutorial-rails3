# Be sure to restart your server when you modify this file.

  Rails.application.config.cache_store = :mem_cache_store, 'localhost:11212'

  require 'memcache'
  
  Rails.application.config.after_initialize do  
    CACHE = MemCache.new
    CACHE.servers = 'localhost:11212'

    Rails.application.config.session_store = :mem_cache_store

    Rails.application.config.session = {
      :session_key => '_session',
      :session_domain => '.netzke-tutorial.net',
      :secret      => 'my_secret',
      :cache => CACHE
    }
  end

# Rails.application.config.session_store :cookie_store, :key => '_netzke-rails3-playground_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# Rails.application.config.session_store :active_record_store
