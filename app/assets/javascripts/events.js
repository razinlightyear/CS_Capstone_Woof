// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

var map;
var allMarkers = [];
var markerObjectsId = [];

var icons = {};

function initMap() {

  // Below is done because when updating the events, it doesn't display anything onto the map  
  allMarkers = [];
  markerObjectsId = [];

  // 40.75, -111.84
  // 40.716, -111.93
  // 40.874, -112.13
  // 40.846, -112.08

  var myLatLng = {lat: 40.768, lng: -111.845}
  //var myLatLng;

  icons = {
    LostDog:{
      icon: '/assets/lost-dog.png'
    },
    FoundDog:{
      icon: '/assets/found-dog.png'
    },
    PostEvent:{
      icon: '/assets/walking-the-dog.png'
    }
  };

  //if(navigator.geolocation){


    //navigator.geolocation.getCurrentPosition(function(position){
      /*myLatLng = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };*/

      map = new google.maps.Map(document.getElementById('map'), {
        center: myLatLng,
        //zoom: 15
        zoom: 13
      });

      /*map.addListener('click', function(e){
        console.log("Latitude is: " + e.latLng.lat());
        console.log("Longitude is: " + e.latLng.lng());
      });*/

      get_all_events();

    //});
  //}


  /*else{
    console.log("There is an error");
    // Handle the error of not able to get the user location
  }*/


}


function gather_filters(current_user_id)
{
  var filter_selected = $("input[class = 'form-check-input filter_map']:checked");
  
  filter_array = []

  filter_selected.each(function(i, filter){

    if(!filter.disabled)
      filter_array.push(filter.value);
    
  });

  remove_markers(filter_array, current_user_id);

}

function disable_filters(current_user_id)
{

  $('#filter_lost').prop('disabled', function(i, v){ return !v});
  $('#filter_found').prop('disabled', function(i, v){ return !v});
  $('#filter_all').prop('disabled', function(i, v){ return !v});
  $('#filter_post_event').prop('disabled', function(i, v){ return !v});

  gather_filters(current_user_id);

}

function remove_markers(filter_array, current_user_id)
{

  allMarkers.map(function(marker){
  // console.log("Marker label is: " + marker.getLabel());

    if(filter_array.includes("Personal"))
    {

      if(marker.user_id === current_user_id)
      {
        marker.setMap(map);
      }
      else
      {
        marker.setMap(null);
      }

      // Filter the events that are created by the user.
      //console.log("Marker is: ");
      //console.log(marker);
    }
    else
    {
      if(filter_array.includes("All"))
      {
        marker.setMap(map);
      }
      else
      {
        if(filter_array.includes(marker.getLabel()))
        {
          // console.log("Hello Everyone");
          marker.setMap(map);
        }
        else
        {
          marker.setMap(null);
        }
      }
    }

  });
}

function remove_event_for_update(event_id)
{
  event_id = parseInt(event_id);
  var index = markerObjectsId.indexOf(event_id);
  markerObjectsId.splice(index, 1);

  for(var i = 0; i < allMarkers.length; i++)
  {
    if(allMarkers[i].event_id == event_id)
    {
      allMarkers[i].setMap(null);
      allMarkers.splice(i, 1);
      break;
    }
  }


  get_all_events();
}

function get_all_events(filter_array)
{

 //console.log("I am in the get all events function");

  /// Make an AJAX call to events_map action in events_controller
  jQuery.ajax({
    url: '/events_map',
    dataType: 'json',
    type: 'GET',

    success: function(data){
      //console.log("filter_array is: " + filter_array);

      if(typeof filter_array!='undefined')
      {
        //console.log("Marker is: ");
        //console.log(marker);
      }
      else
      {
        data.events.map(function(marker){

          if(markerObjectsId.includes(marker.event_id))
          {
            //console.log("This marker is in the list");
            // draw_marker(marker);
          }
          else
          {
            //console.log("This marker is not in the list");
            markerObjectsId.push(marker.event_id);
            draw_marker(marker);
          }


        });
      }

    },
    error: function(data){
      console.log("Error is: " + data.error);
      console.log("Status is: " + data.status);
    }
  });

}


function draw_marker(data)
{
  //console.log("I am drawing the marker");
  //console.log("Marker is: ");
  //console.log(data);

  var marker;
  if(data.event_type!='WalkingPartner')
  {  
    marker = new google.maps.Marker({
        position: {lat: parseFloat(data.latitude), lng: parseFloat(data.longitude)},
        map: map,
        animation: google.maps.Animation.DROP,
        icon: icons[data.event_type].icon,
        user_id: data.user_id,
        event_id: data.event_id
    });

    //console.log(marker);

  var contentString = "";

  if(data.event_type == 'LostDog')
  {

    contentString = 
    "<div class = 'list-group'>"+
      "<li class = 'list-group-item'><h5>" + data.first_name + ' '  + data.last_name + "</h5></li>" +
      "<li class = 'list-group-item'><h5>" + data.event_type + ": " + data.pet_name + "</h5></li>" +
      "<li class = 'list-group-item'><p><h5> Description: </h5><br>" + data.description + "</p></li>" +
      "<li class = 'list-group-item'><p><h5>Address: </h5><br> " + data.address + "</p></li>";

    /*
    contentString = " <div class = 'event_window'>"+
              "<h5>" + data.pet_name + "</h5>" +
              "<h5>"+ data.event_type +"</h5>"+
              "<h5>Posted By: "+data.first_name + data.last_name+"</h5>"+
              "<p>Description: " + data.description + "<br>"+
              "Address: " + data.address + "</p>";*/
    
    marker.setLabel("LostDog");
  }
  else if(data.event_type == 'FoundDog')
  {
    contentString = 
    "<div class = 'list-group'>"+
      "<li class = 'list-group-item'><h5>" + data.first_name + ' '  + data.last_name + "</h5></li>" +
      "<li class = 'list-group-item'><h5>" + data.event_type + "</h5></li>" +
      "<li class = 'list-group-item'><p><h5> Description: </h5><br>" + data.description + "</p></li>" +
      "<li class = 'list-group-item'><p><h5>Address: </h5><br> " + data.address + "</p></li>";

    /*
    contentString = " <div class = 'event_window'>"+
              "<h5>"+ data.event_type +"</h5>"+
              "<h5>Posted By: "+data.first_name + data.last_name+"</h5>"+
              "<p>Description: " + data.description + "<br>" + 
              "Address: " + data.address + "</p>";*/
    
    marker.setLabel("FoundDog");
  }
  else if(data.event_type == 'PostEvent')
  {

    contentString = 
    "<div class = 'list-group'>"+
      "<li class = 'list-group-item'><h5>" + data.first_name + ' '  + data.last_name + "</h5></li>" +
      "<li class = 'list-group-item'><h5>" + data.event_type + "</h5></li>" +
      "<li class = 'list-group-item'><p><h5> Description: </h5><br>" + data.description + "</p></li>" +
      "<li class = 'list-group-item'><p><h5>Address: </h5><br> " + data.address + "</p></li>";

    /*
    contentString = " <div class = 'event_window'>"+
              "<h5>"+ data.event_type +"</h5>"+
              "<h5>Posted By: "+data.first_name + data.last_name+"</h5>"+
              "<p>Description: " + data.description + "<br>" + 
              "Address: " + data.address + "</p>"; */
    
    marker.setLabel('PostEvent');
  }

  var link = '';

  if(data.event_type == 'LostDog' )
  {
   // link = "<a href='/lost_dogs/"+data.event_id+"' class='btn btn-primary' data-toggle='modal' data-target=" + "'#eventModel' data-remote = 'true'>More Details</a>";
    link = "<a href='/lost_dogs/" + data.event_id + "' class='list-group-item list-group-item-action list-group-item-info' data-toggle='modal' data-target=" + "'#eventModel' data-remote = 'true'>More Details</a></div>";
  }
  else if(data.event_type == 'FoundDog')
  {
    //link = "<a href='/found_dogs/"+data.event_id+"' class='btn btn-primary' data-toggle='modal' data-target=" + "'#eventModel' data-remote = 'true'>View Details</a></div>";

    link = "<a href='/found_dogs/" + data.event_id + "' class='list-group-item list-group-item-action list-group-item-info' data-toggle='modal' data-target=" + "'#eventModel' data-remote = 'true'>More Details</a></div>";    
  }
  else if(data.event_type == 'PostEvent')   // This needs to be given more thought.
  {
    //link = "<a href='/post_events/"+data.event_id+"' class='btn btn-primary' data-toggle='modal' data-target=" + "'#eventModel' data-remote = 'true'>View Details</a></div>";  

    link = "<a href='/post_events/"+data.event_id+"' class='list-group-item list-group-item-action list-group-item-info' data-toggle='modal' data-target=" + "'#eventModel' data-remote = 'true'>More Details</a></div>";
  }

  contentString = contentString + link;

  var infoWindow = new google.maps.InfoWindow({
    content: contentString
  });

  marker.addListener('click',function(){
    infoWindow.open(map, marker);
  });


  allMarkers.push(marker);

  }
}

function open_event_section()
{
  //document.getElementById("event-section").style.width = "250px";

  $("#event-content").html("This is awesome");
  $("#event-section").css("width", "450px");

}

function close_event_section()
{
  $("#event-content").html("");
  $("#event-section").css("width", "0px");
  $("#event-section").css("height", "0px");
}


function open_filter_menu()
{
  var filter_menu_height = $("#map-filter-form").css("height");
  $("#map-filter-form").show("2000");

  var map_height = $("#map").css("height");
  map_height = parseInt(map_height) - parseInt(filter_menu_height);
  $("#map").css("height", map_height);

  var filter_button_values = $("#google-filter-button button");
  filter_button_values.text("Close Filter Menu");
  filter_button_values.attr("onclick", "close_filter_menu();");
}

function close_filter_menu()
{
  var filter_menu_height = $("#map-filter-form").css("height");
  $("#map-filter-form").hide(1000);

  var map_height = $("#map").css("height");
  map_height = parseInt(map_height) + parseInt(filter_menu_height);
  $("#map").css("height", map_height);

  var filter_button_values = $("#google-filter-button button");
  filter_button_values.text("Open Filter Menu");
  filter_button_values.attr("onclick", "open_filter_menu();");

  // Close the filter menu here
}