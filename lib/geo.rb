module Geo

  def self.rad(degrees)
    degrees*(Math::PI/180)
  end

  def self.calculate_displacement(point1, point2)
    lat1 = point1[0]
    lon1 = point1[1]
    lat2 = point2[0]
    lon2 = point2[1]

    r = 6371 #km
    dLat = rad(lat2-lat1)
    dLon = rad(lon2-lon1)
    a = Math.sin(dLat/2) * Math.sin(dLat/2) +
      Math.cos(rad(lat1)) * Math.cos(rad(lat2)) *
      Math.sin(dLon/2) * Math.sin(dLon/2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    r * c
  end

end