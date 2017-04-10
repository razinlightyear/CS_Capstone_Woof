# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

###
parameters = 
  center:
    lat: 40.7608
    lng: -111.8910
  zoom: 8
map = undefined

initMap = ->
  map = new (google.maps.Map)(document.getElementById('map-canvas'), parameters)
  return

  ###