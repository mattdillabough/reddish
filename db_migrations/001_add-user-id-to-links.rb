require 'sqlite3'

db = SQLite3::Database.new '../reddish.sqlite'
db.execute('UPDATE links SET user_id = (SELECT id FROM users WHERE email = "mattdillabough@gmail.com")' +
           ' WHERE user_id IS NULL')