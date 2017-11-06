# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  $('.thumb-image-modal').click (e) ->
    pet_id = this.dataset.petId
    $.ajax
      url: '/pets/'+pet_id+'/image_modal'
      timeout: 500
      type: 'get'
      dataType: 'script'
      error: (jqXHR, textStatus, errorThrown) ->
        alert errorThrown
      success: (data, textStatus, jqXHR) ->
        # Replace the modal body with form of the image. This is done in the image_modal.js.erb
