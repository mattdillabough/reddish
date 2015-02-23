require 'sqlite3'

db = SQLite3::Database.new '../reddish.sqlite'
#db.execute('ALTER TABLE links ADD COLUMN created_at INTEGER')
# Two weeks ago approximation for existing links.
db.execute('UPDATE links SET created_at=1408940415')