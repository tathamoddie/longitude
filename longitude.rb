require 'rubygems'
require 'sinatra'
require 'haml'

get '/' do
  haml :default
end