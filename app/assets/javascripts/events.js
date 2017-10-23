// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

/*

parameters = 
  center:
    lat: 40.7608
    lng: -111.8910
  zoom: 8
map = undefined

initMap = ->
  map = new (google.maps.Map)(document.getElementById('map-canvas'), parameters)
  return

*/

var map;
function initMap() {

  // 40.75, -111.84
  // 40.716, -111.93
  // 40.874, -112.13
  // 40.846, -112.08

  var myLatLng = {lat: 40.75, lng: -111.84}

  map = new google.maps.Map(document.getElementById('map'), {
    center: myLatLng,
    zoom: 10
  });

  /*map.addListener('click', function(e){
    console.log("Latitude is: " + e.latLng.lat());
    console.log("Longitude is: " + e.latLng.lng());
  });*/

  let markers;

  /// Make an AJAX call to events_map action in events_controller
  jQuery.ajax({
    url: '/events_map',
    dataType: 'json',
    type: 'GET',
    success: (data) => {
      markers = data;
      markers.events.map((marker) => {
        draw_marker(marker);
      });
    },
    error: function(data){
      console.log("Error is: " + data.error);
      console.log("Status is: " + data.status);
    }
  });
}


function draw_marker(data)
{

  var marker = new google.maps.Marker({
      position: {lat: parseFloat(data.latitude), lng: parseFloat(data.longitude)},
      map: map
  });

  var contentString = "";

  if(data.event_type != 'FoundDog')
    contentString = " <div class = 'event_window'>"+
              "<h5>" + data.pet_name + "</h5>" +
              "<h5>"+ data.event_type +"</h5>"+
              "<h5>Posted By: "+data.first_name + data.last_name+"</h5>"+
              "<p>Description: " + data.description + "</p>";
  else
    contentString = " <div class = 'event_window'>"+
              "<h5>"+ data.event_type +"</h5>"+
              "<h5>Posted By: "+data.first_name + data.last_name+"</h5>"+
              "<p>Description: " + data.description + "</p>";

  var link = '';

  if(data.event_type == 'LostDog' )
    link = "<a href='/lost_dogs/"+data.event_id+"' class='btn btn-primary' data-toggle='modal' data-target=" + "'#eventModel' data-remote = 'true'>View Event</a>";
  else if(data.event_type == 'FoundDog')
    link = "<a href='/found_dogs/"+data.event_id+"' class='btn btn-primary' data-toggle='modal' data-target=" + "'#eventModel' data-remote = 'true'>View Details</a></div>";

  contentString = contentString + link;


  var infoWindow = new google.maps.InfoWindow({
    content: contentString
  });

  marker.addListener('click',function(){
    infoWindow.open(map, marker);
  });
}
