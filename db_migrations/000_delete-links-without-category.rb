require 'sqlite3'

db = SQLite3::Database.new '../reddish.sqlite'
db.execute('DELETE FROM links WHERE category_id IS NULL')