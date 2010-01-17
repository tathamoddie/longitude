require 'rubygems'
require 'sinatra'
require 'haml'

get '/' do
  haml :default
end

get '/styles.css' do
  header 'Content-Type' => 'text/css; charset=utf-8'
  sass :styles
end