require 'sinatra'
require 'sqlite3'

module Reddull
  def Reddull.database
    SQLite3::Database.new 'reddull.sqlite'
  end
  
  def Reddull.username_by_id(user_id)
    db = Reddull.database
    users = db.execute('SELECT username FROM users WHERE id = ? LIMIT 1', [user_id])
    if users.size > 0
      return users[0][0]
    end
  end
end