# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  #$('.pet-image-form').on 'change', '.pet-image-field', (e) ->
  $('.pet-image-form').on 'change', '.pet-image-field', (e) ->
    pet_id = this.dataset.petId
    $('#pet_'+pet_id+'_image_form').submit()
