require 'rubygems'
require 'sinatra'
require 'haml'
require 'twitter'
require 'json'

load "#{File.dirname(__FILE__)}/lib/geo.rb"

get '/styles.css' do
  header 'Content-Type' => 'text/css; charset=utf-8'
  sass :styles
end

get %r{/([\w]*)$} do |id|
  @feed_path = "/#{id}/feed.kml"
  haml :default
end

get %r{/([\w]*)/feed.([\w]+)$} do |id,format|
  header 'Content-Type' => 'application/vnd.google-earth.kml+xml'

  timeline = Twitter.timeline(id, { :count => 200 })

  if timeline.length == 0 then
    raise Sinatra::NotFound, "No tweets found in timeline."
  end

  @coordinates = [1,2,3]
  for i in (0..timeline.length-1)
    tweet = timeline[i]
    next if tweet.geo == nil
    next if tweet.geo.type != "Point"
#    if @coordinates.length > 0 then
#      # ignore it if it's within 500m of the last point
#      next if Geo.calculate_displacement(@coordinates[@coordinates.length-1], tweet.geo.coordinates) < 0.5
#    end
    @coordinates.push(tweet.geo.coordinates)
  end

  if (format == 'kml') then
    haml :kml
  elsif (format == 'json') then
    @coordinates.to_json
  else
    raise Sinatra::NotFound, "Format not recognized."
  end
end