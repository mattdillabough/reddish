require 'bcrypt'
require 'sinatra'
require 'sinatra/content_for'
require 'sqlite3'

enable :sessions

get '/' do 
  user_id = session[:user_id]
  if user_id
    db = SQLite3::Database.new 'reddull.sqlite'
    users = db.execute('SELECT username FROM users WHERE id = ? LIMIT 1',
      [user_id])
    if users.size > 0
      @username = users[0][0]
    end
  end
  erb :index
end

get '/login' do
  erb :login
end

post '/login' do
  db = SQLite3::Database.new 'reddull.sqlite'
  users = db.execute('SELECT id, password FROM users WHERE username = ? LIMIT 1', [params[:username]])  
  # [ [1, 'abc544334fdd001'] ]
  if users.size == 0
    @error = 'No user with that username or password found!'
    return erb :login
  end

  hashed_password = BCrypt::Password.new(users[0][1])
  if hashed_password != params[:password]
    @error = 'No user with that username or password found!'
    return erb :login
  end
  
  session[:user_id] = users[0][0]
  redirect '/'
end

get '/logout' do
  session[:user_id] = nil
  redirect '/'
end

get '/register' do
   erb :register
end


post '/register' do
  db = SQLite3::Database.new 'reddull.sqlite'
 
  # TODO: Only allow each username once
  hashed_password = BCrypt::Password.create(params[:password])
  
  db.execute('INSERT INTO users (email, username, password) VALUES (?, ?, ?)',
    [params[:email], params[:username], hashed_password])
  redirect '/'
end

