ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")
class Bookmark < ActiveRecord::Base; end

class Word < ActiveRecord::Base
  
end

