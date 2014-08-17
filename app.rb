require 'bcrypt'
require 'sinatra'
require 'sinatra/content_for'
require 'sqlite3'

require_relative 'logic'

enable :sessions

before do
  if session[:flash]
    @flash = session[:flash]
    session[:flash] = nil
  end
  pass
end

get '/' do 
  db = Reddull::database
  @links = db.execute('SELECT id, title, description, url, category_id FROM links')
  categories = db.execute('SELECT id, name FROM categories')  # [ [1, 'World news'], [2, 'Local News'], ... ]
  @category_id_to_name = Hash[categories]
  
  @category_id_to_links = {}
  @links.each do |link|
    link_category_id = link[4]
    if @category_id_to_links.has_key?(link_category_id)
      @category_id_to_links[link_category_id] << link
    else
      @category_id_to_links[link_category_id] = [link]
    end
  end
  
  user_id = session[:user_id]
  if user_id
    @username = Reddull::username_by_id(user_id)
  end
  erb :index
end

get '/login' do
  erb :login
end

post '/login' do
  db = Reddull::database
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
  db = Reddull::database
 
  # TODO: Only allow each username once
  hashed_password = BCrypt::Password.create(params[:password])
  
  db.execute('INSERT INTO users (email, username, password) VALUES (?, ?, ?)',
    [params[:email], params[:username], hashed_password])
  redirect '/'
end

get '/links/new' do
  if !session[:user_id]
    session[:flash] = "You must log in to view that page"
    redirect '/'
  end
  erb :'links/new'
end

post '/links/new' do
  if !session[:user_id]
    session[:flash] = "You must log in to view that page"
    redirect '/'
  end
  db = Reddull::database
  db.execute('INSERT INTO links (title, description, url, category_id) VALUES(?, ?, ?, ?)',
    [params[:title], params[:description], params[:url], params[:category_id]])
  # The user has successfully created a newslink, redirect back to the homepage
  redirect '/'
end
