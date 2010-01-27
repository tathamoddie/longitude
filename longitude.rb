require 'rubygems'
require 'sinatra'
require 'haml'
require 'twitter'
require 'json'

load "#{File.dirname(__FILE__)}/lib/geo.rb"

get '/styles.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :styles
end

get %r{/([\w]*)$} do |id|
  @feed_path = "/#{id}/feed.kml"
  haml :default
end

get %r{/([\w]*)/feed.([\w]+)$} do |id,format|
  response.headers['Cache-Control'] = 'public, max-age=300'

  timeline = Twitter.timeline(id, { :count => 200 })

  if timeline.length == 0 then
    raise Sinatra::NotFound, "No tweets found in timeline."
  end

  points = []
  for i in (0..timeline.length-1)
    break if points.length > 25
    tweet = timeline[i]
    next if tweet.geo == nil
    next if tweet.geo["type"] != "Point"
    if points.length > 0 then
      # ignore it if it's within 500m of the last point
      next if Geo.calculate_displacement(points[points.length-1][0], tweet.geo.coordinates) < 0.5
    end
    points << [ tweet.geo.coordinates, tweet.created_at ]
  end

  if (format == 'kml') then
    content_type 'application/vnd.google-earth.kml+xml', :charset => 'utf-8'
    haml :kml, :locals => { :points => points, :id => id }
  elsif (format == 'json') then
    content_type 'application/json', :charset => 'utf-8'
    points.to_json
  else
    raise Sinatra::NotFound, "Format not recognized."
  end
end