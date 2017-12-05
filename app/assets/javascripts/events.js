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

  //var myLatLng = {lat: 40.768, lng: -111.845}
  var myLatLng;

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

  if(navigator.geolocation){

    navigator.geolocation.getCurrentPosition(function(position){
      myLatLng = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };

      map = new google.maps.Map(document.getElementById('map'), {
        center: myLatLng,
        zoom: 13
      });

      google.maps.event.addListenerOnce(map, 'idle', function(){

      map.addListener('rightclick', function(e){

      var latitude = e.latLng.lat();
      var longitude = e.latLng.lng();
      
      var geocoder;
      geocoder = new google.maps.Geocoder();

      geocoder.geocode({"location": {"lat": latitude, "lng": longitude}}, function(results){
          
          address_event = results[0].formatted_address;


          $('.modal-body.event_content').html('<div id = "context-menu" class="list-group">'+
          '<button type="button" class="list-group-item list-group-item-action" id = "lost_dog_form">Lost Dog</button>'+
          '<button type="button" class="list-group-item list-group-item-action" id = "found_dog_form">Found Dog</button>'+
          '<button type="button" class="list-group-item list-group-item-action" id = "around_me_form">AroundMe Event</button>'+
          '<button type="button" class="list-group-item list-group-item-action"><strong>Address:</strong>'+address_event+'</button></div>');

          $('#eventModal').modal('show');
          $('.modal-title').text("Choose the event type");

          $('#lost_dog_form').click(function(d){

            jQuery.ajax({
              url: '/lost_dogs/new',
              dataType: 'script',
              type: 'GET',
              data: { lost_dog : {latitude: latitude, longitude: longitude,address: address_event} },
              success: function(data){
                $('#lost_dog_address').prop('disabled', true);
              },
              error: function(data){
                console.log("Error is: " + data.error);
                console.log("Status is: " + data.status);
              }
            });

          });

          $('#found_dog_form').click(function(d){
            jQuery.ajax({
              url: '/found_dogs/new',
              dataType: 'script',
              type: 'GET',
              data: { found_dog : {latitude: latitude, longitude: longitude,address: address_event} },
              success: function(data){
                $('#found_dog_address').prop('disabled', true);
              },
              error: function(data){
                console.log("Error is: " + data.error);
                console.log("Status is: " + data.status);
              }
            });
          });

          $('#around_me_form').click(function(d){
            jQuery.ajax({
              url: '/post_events/new',
              dataType: 'script',
              type: 'GET',
              data: { post_event : {latitude: latitude, longitude: longitude,address: address_event} },
              success: function(data){
                $('#post_event_address').prop('disabled', true);
              },
              error: function(data){
                console.log("Error is: " + data.error);
                console.log("Status is: " + data.status);
              }
            });


          });

        });

        });
      });

      get_all_events();

    });
  }
  else{

    console.log("There is an error in getting the location. So we are locating at salt lake city");
    
    myLatLng = {lat: 40.768, lng: -111.845}

    map = new google.maps.Map(document.getElementById('map'), {
      center: myLatLng,
      zoom: 13
    });

    get_all_events();
  }
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

// When all is selected, then other filters should be disabled
function disable_other_filters()
{
  $('#filter_lost').prop('disabled', function(i, v){ return !v});
  $('#filter_found').prop('disabled', function(i, v){ return !v});
  $('#filter_post_event').prop('disabled', function(i, v){ return !v});
  $('#filter_personal').prop('disabled', function(i, v){ return !v});

  gather_filters();
}

// When viewing my posted events, all other events should be disabled
function disable_my_filters(current_user_id)
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

  /// Make an AJAX call to events_map action in events_controller
  jQuery.ajax({
    url: '/events_map',
    dataType: 'json',
    type: 'GET',

    success: function(data){

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
          }
          else
          {
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

    // Checking whether the marker is in map.
    if(!map.getBounds().contains(marker.getPosition()))
    {
      //map.fitBounds(marker.position);
      map.getBounds().extend(marker.getPosition());
      map.fitBounds(map.getBounds());
    }

  var contentString = "";

  if(data.event_type == 'LostDog')
  {

    contentString = 
    "<div class = 'list-group'>"+
      "<li class = 'list-group-item'><strong>Posted By:</strong><strong>&nbsp;" + data.first_name + ' '  + data.last_name + "</strong></li>" +
      "<li class = 'list-group-item'><h5>Lost Dog: " + data.pet_name + "</h5></li>";
    
    marker.setLabel("Lost Dog");
  }
  else if(data.event_type == 'FoundDog')
  {
    contentString = 
    "<div class = 'list-group'>"+
      "<li class = 'list-group-item'><strong>Posted By:</strong><strong>&nbsp;" + data.first_name + ' '  + data.last_name + "</strong></li>" +
      "<li class = 'list-group-item'><h5>Found Dog</h5></li>";

    /*
    contentString = " <div class = 'event_window'>"+
              "<h5>"+ data.event_type +"</h5>"+
              "<h5>Posted By: "+data.first_name + data.last_name+"</h5>"+
              "<p>Description: " + data.description + "<br>" + 
              "Address: " + data.address + "</p>";*/
    
    marker.setLabel("Found Dog");
  }
  else if(data.event_type == 'PostEvent')
  {

    contentString = 
    "<div class = 'list-group'>"+
      "<li class = 'list-group-item'><strong>Posted By:</strong><strong>&nbsp;" + data.first_name + ' '  + data.last_name + "</strong></li>" +
      "<li class = 'list-group-item'><h5>Around Me Event</h5></li>";
    
    marker.setLabel('Around Me');
  }

  var link = '';

  if(data.event_type == 'LostDog' )
  {
   // link = "<a href='/lost_dogs/"+data.event_id+"' class='btn btn-primary' data-toggle='modal' data-target=" + "'#eventModel' data-remote = 'true'>More Details</a>";
    link = "<a onclick = 'panMap("+marker.position.lat()+","+marker.position.lng()+")' href='/lost_dogs/" + data.event_id + "' class='list-group-item list-group-item-action list-group-item-info' data-toggle='modal' data-target=" + "'#eventModel' data-remote = 'true'>More Details</a></div>";
  }
  else if(data.event_type == 'FoundDog')
  {
    link = "<a onclick = 'panMap("+marker.position.lat()+","+marker.position.lng()+")' href='/found_dogs/" + data.event_id + "' class='list-group-item list-group-item-action list-group-item-info' data-toggle='modal' data-target=" + "'#eventModel' data-remote = 'true'>More Details</a></div>";    
  }
  else if(data.event_type == 'PostEvent')   // This needs to be given more thought.
  {
    link = "<a onclick = 'panMap("+marker.position.lat()+","+marker.position.lng()+")' href='/post_events/"+data.event_id+"' class='list-group-item list-group-item-action list-group-item-info' data-toggle='modal' data-target=" + "'#eventModel' data-remote = 'true'>More Details</a></div>";
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

function panMap(newLat, newLng)
{
  var newCenter = {lat: parseFloat(newLat), lng: parseFloat(newLng)};
  map.panTo(newCenter);
}

function open_event_section()
{

  $("#event-content").html("This is awesome");
  $("#event-section").css("width", "450px");

}


$(document).on('turbolinks:load', function() {
  $('body').on('click', '.event-invite-btn', function() {
    if ($(this).text() === 'Invite Person') {
      $('#event_invite_card').show();
      return $(this).html('Cancel invite');
    } else {
      $('#event_invite_card').hide();
      return $(this).html('Invite Person');
    }
  });
  
  $('.contact-owner').click(function(e) {
    var event_id;
    event_id = this.dataset.eventId;
    return $.ajax({
      url: '/events/' + event_id + '/contact_owner_modal_body',
      timeout: 500,
      type: 'get',
      dataType: 'script',
      error: function(jqXHR, textStatus, errorThrown) {
        return alert(errorThrown);
      },
      success: function(data, textStatus, jqXHR) {}
    });
  });
  
  $('.view-messaging-users').click(function(e) {
    var event_id;
    event_id = this.dataset.eventId;
    return $.ajax({
      url: '/events/' + event_id + '/view_messages_modal_body',
      timeout: 500,
      type: 'get',
      dataType: 'script',
      error: function(jqXHR, textStatus, errorThrown) {
        return alert(errorThrown);
      },
      success: function(data, textStatus, jqXHR) {}
    });
  });
  
  $('body').on('click', '.view-messages-btn', function() {
    var other_user_id, event_id;
    other_user_id = this.dataset.otherUserId;
    event_id = this.dataset.eventId;
    return $.ajax({
      url: '/events/' + event_id + '/view_message_from_user_modal_body?other_user='+other_user_id,
      timeout: 500,
      type: 'get',
      dataType: 'script',
      error: function(jqXHR, textStatus, errorThrown) {
        return alert(errorThrown);
      },
      success: function(data, textStatus, jqXHR) {}
    });
  });
  
  $('body').on('click', '.join-event-btn', function() {
    var event_id;
    event_id = this.dataset.eventId;
    return $.ajax({
      url: '/events/' + event_id + '/join',
      timeout: 500,
      type: 'get',
      dataType: 'script',
      error: function(jqXHR, textStatus, errorThrown) {
        return alert(errorThrown);
      },
      success: function(data, textStatus, jqXHR) {}
    });
  });
  
  $('body').on('click', '.disjoin-event-btn', function() {
    var event_id;
    event_id = this.dataset.eventId;
    return $.ajax({
      url: '/events/' + event_id + '/disjoin',
      timeout: 500,
      type: 'get',
      dataType: 'script',
      error: function(jqXHR, textStatus, errorThrown) {
        return alert(errorThrown);
      },
      success: function(data, textStatus, jqXHR) {}
    });
  });
  
  lost_dog_table = $('#lost_dogs_table').DataTable({
    "columnDefs": [
      {
          "targets": [ 'invisible' ],
          "visible": false,
          "searchable": true
      },
      {
          "targets": [ 'no-search' ],
          "visible": true,
          "searchable": false
      }
    ]
  });
  
  found_dog_table = $('#found_dogs_table').DataTable({
    "columnDefs": [
      {
          "targets": [ 'invisible' ],
          "visible": false,
          "searchable": true
      },
      {
          "targets": [ 'no-search' ],
          "visible": true,
          "searchable": false
      }
    ]
  });
  
  document.addEventListener('turbolinks:before-cache', function() {
    if (lost_dog_table !== null) {
     lost_dog_table.destroy();
     lost_dog_table = null;
     found_dog_table.destroy();
     found_dog_table = null;
    }
  });
});

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
  filter_button_values.text("Close Google Map Menu");
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
  filter_button_values.text("Your Google Map Menu");
  filter_button_values.attr("onclick", "open_filter_menu();");
}
