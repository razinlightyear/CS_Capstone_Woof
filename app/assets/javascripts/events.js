// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

var map;
function initMap() {
  
  console.log("I am in the init Map function");

  // 40.75, -111.84
  // 40.716, -111.93
  // 40.874, -112.13
  // 40.846, -112.08

  //var myLatLng = {lat: 40.75, lng: -111.84}
  var myLatLng;

  if(navigator.geolocation){


    navigator.geolocation.getCurrentPosition(function(position){
      myLatLng = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };

      map = new google.maps.Map(document.getElementById('map'), {
        center: myLatLng,
        zoom: 10
      });

      map.addListener('click', function(e){
        console.log("Latitude is: " + e.latLng.lat());
        console.log("Longitude is: " + e.latLng.lng());
      });

      get_all_events();

    });
  }
  else{
    console.log("There is an error");
    // Handle the error of not able to get the user location
  }
}


function get_all_events()
{

  console.log("I am in the get all events function");

  /// Make an AJAX call to events_map action in events_controller
  jQuery.ajax({
    url: '/events_map',
    dataType: 'json',
    type: 'GET',
    success: (data) => {
      data.events.map((marker) => {
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
  {
    contentString = " <div class = 'event_window'>"+
              "<h5>" + data.pet_name + "</h5>" +
              "<h5>"+ data.event_type +"</h5>"+
              "<h5>Posted By: "+data.first_name + data.last_name+"</h5>"+
              "<p>Description: " + data.description + "<br>"+
              "Address: " + data.address + "</p>";
  }
  else
    contentString = " <div class = 'event_window'>"+
              "<h5>"+ data.event_type +"</h5>"+
              "<h5>Posted By: "+data.first_name + data.last_name+"</h5>"+
              "<p>Description: " + data.description + "<br>" + 
              "Address: " + data.address + "</p>";

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


