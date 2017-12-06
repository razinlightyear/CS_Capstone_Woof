// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require moment
//= require datatables
//= require turbolinks
//= require tether
//= require bootstrap-sprockets
//= require underscore
//= require select2
//= require bootstrap-filestyle.min
//= require bootstrap-datetimepicker.js
//= require_tree .
//= require_tree ./channels

$(document).on('turbolinks:load', function() {

  var filter_height = $('#map-filter-form').css('height');
  $('#map-filter-form').hide();
  var height = $('#map').css('height');
  height = parseInt(height) + parseInt(filter_height);
  $('#map').css('height', height);

  $('#profile_pic').popover({
          html :     true,
          placement: "left",
          title:     "Valued User",
          trigger:   "focus",
          content:   "User profile stuff goes here",
  });
  $('#profile_pic').on("click",function(e){
    e.preventDefault();
  });
  
  $('body').on('click', '.thumb-image-modal', function() {
    var id, controller;
    id = this.dataset.id;
    controller = this.dataset.controller;
    return $.ajax({
      url: '/' + controller + '/' + id + '/image_modal',
      timeout: 500,
      type: 'get',
      dataType: 'script',
      error: function(jqXHR, textStatus, errorThrown) {
        return alert(errorThrown);
      },
      success: function(data, textStatus, jqXHR) {}
    });
  });
});

function bindSelect2Elements(){
  $('.breed-selector').select2({
    placeholder: 'Select breed',
    allowClear: true,
    theme: 'bootstrap',
    width: "resolve",
    ajax: {
      url: '/breeds/find',
      data: function(params) {
        return {
          name: params.term
        };
      },
      dataType: 'json',
      delay: 500,
      processResults: function(data, params) {
        return {
          results: _.map(data, function(el) {
            return {
              id: el.id,
              name: el.name
            };
          })
        };
      },
      cache: true
    },
    escapeMarkup: function(markup) {
      return markup;
    },
    minimumInputLength: 2,
    templateResult: function(item) {
      return item.name;
    },
    templateSelection: function(item) {
      return item.name || item.text;
    }
  });

  $('.colors-selector').select2({
    placeholder: 'Select Colors',
    allowClear: true,
    theme: 'bootstrap',
    width: "resolve",
    ajax: {
      url: '/colors/find',
      data: function(params) {
        return {
          name: params.term
        };
      },
      dataType: 'json',
      delay: 500,
      processResults: function(data, params) {
        return {
          results: _.map(data, function(el) {
            return {
              id: el.id,
              name: el.badge
            };
          })
        };
      },
      cache: true
    },
    escapeMarkup: function(markup) {
      return markup;
    },
    minimumInputLength: 2,
    templateResult: function(item) {
      return item.name;
    },
    templateSelection: function(item) {
      return item.name || item.text;
    }
  });

  $('.weight-selector').select2({
    placeholder: 'Select weight range',
    allowClear: true,
    theme: 'bootstrap',
    width: "resolve"
  });
  
  $('.group-invitee-selector').select2({
    placeholder: 'Search for a user to invite',
    allowClear: true,
    theme: 'bootstrap',
    width: "resolve",
    tags: true,
    ajax: {
      url: '/users/find',
      data: function(params) {
        return {
          name: params.term,
          group_id: $(this).data('group-id')
        };
      },
      dataType: 'json',
      delay: 500,
      processResults: function(data, params) {
        return {
          results: _.map(data, function(el) {
            return {
              id: el.id,
              name: el.name
            };
          })
        };
      },
      cache: true
    },
    escapeMarkup: function(markup) {
      return markup;
    },
    minimumInputLength: 2,
    templateResult: function(item) {
      return item.name;
    },
    templateSelection: function(item) {
      return item.name || item.text;
    }
  });
}

function bindSelect2EventInvite(){
  $('.event-invitee-selector').select2({
    placeholder: 'Search for a user to invite',
    allowClear: true,
    theme: 'bootstrap',
    width: "resolve",
    tags: true,
    ajax: {
      url: '/users/find',
      data: function(params) {
        return {
          name: params.term,
          event_id: $(this).data('event-id')
        };
      },
      dataType: 'json',
      delay: 500,
      processResults: function(data, params) {
        return {
          results: _.map(data, function(el) {
            return {
              id: el.id,
              name: el.name
            };
          })
        };
      },
      cache: true
    },
    escapeMarkup: function(markup) {
      return markup;
    },
    minimumInputLength: 2,
    templateResult: function(item) {
      return item.name;
    },
    templateSelection: function(item) {
      return item.name || item.text;
    }
  });
}

function highlightSelect2Error(card, select2ClassType){
  selectInput = card.find(select2ClassType).siblings('.select2-container');
  selectInput.addClass('has-danger');

  selectInput.find('.selection').addClass('form-control');
  selectInput.find('.selection').css('padding','0px');
}
