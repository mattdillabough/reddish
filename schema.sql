CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, email, username, password);
CREATE TABLE links (id INTEGER PRIMARY KEY AUTOINCREMENT, title, description, url, category_id INTEGER, user_id INTEGER, upvotes INTEGER, downvotes INTEGER);
CREATE TABLE categories (id INTEGER PRIMARY KEY AUTOINCREMENT, name);


