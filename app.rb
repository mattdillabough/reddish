require 'sinatra'
require "sinatra/content_for"
require 'sqlite3'

get '/' do 
  erb :index
end

get 'login' do
  erb :login
end

get 'register' do
  erb :register
end