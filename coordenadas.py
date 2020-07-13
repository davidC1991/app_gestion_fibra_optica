# -*- coding: utf-8 -*-
"""
Created on Mon Jul 13 09:07:30 2020

@author: Admin
"""


import math



R = 6378.1 #Radius of the Earth
brng = 2.413605255 #Bearing is 90 degrees converted to radians.
d = 0.05 #Distance in km

#lat2  52.20444 - the lat result I'm hoping for
#lon2  0.36056 - the long result I'm hoping for.

lat1 = math.radians(11.226940) #Current lat point converted to radians
lon1 = math.radians(-74.198010) #Current long point converted to radians

lat2 = math.asin( math.sin(lat1)*math.cos(d/R) +
     math.cos(lat1)*math.sin(d/R)*math.cos(brng))

lon2 = lon1 + math.atan2(math.sin(brng)*math.sin(d/R)*math.cos(lat1),
             math.cos(d/R)-math.sin(lat1)*math.sin(lat2))

lat2 = math.degrees(lat2)
lon2 = math.degrees(lon2)
print('-----------')
print(lat2)
print(lon2)
print('-----------')

# origin = geopy.Point(lat1, lon1)
# destination = VincentyDistance(kilometers=d).destination(origin, brng)

# lat_2, lon_2 = destination.latitude, destination.longitude

# print(lat_2)
# print(lon_2)