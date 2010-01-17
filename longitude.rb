require 'rubygems'
require 'sinatra'
require 'haml'
require 'twitter'
require 'json'

load "#{File.dirname(__FILE__)}/lib/geo.rb"

get '/' do
  haml :default
end

get '/styles.css' do
  header 'Content-Type' => 'text/css; charset=utf-8'
  sass :styles
end

get '/location-feed/:id' do |id|
  header 'Content-Type' => 'application/vnd.google-earth.kml+xml'
  timeline = Twitter.timeline(id, { :count => 200 })
  @coordinates = []
  for i in (0..timeline.length-1)
    tweet = timeline[i]
    next if tweet.geo == nil
    next if tweet.geo.type != "Point"
    if @coordinates.length > 0 then
      # ignore it if it's within 500m of the last point
      next if Geo.calculate_displacement(@coordinates[@coordinates.length-1], tweet.geo.coordinates) < 0.5
    end
    @coordinates << tweet.geo.coordinates
  end
  haml :kml
end