require 'sinatra'
require 'sqlite3'

module Reddish
  def Reddish.database
    SQLite3::Database.new 'reddish.sqlite'
  end
  
  def Reddish.username_by_id(user_id)
    db = Reddish.database
    users = db.execute('SELECT username FROM users WHERE id = ? LIMIT 1', [user_id])
    if users.size > 0
      return users[0][0]
    end
  end
end