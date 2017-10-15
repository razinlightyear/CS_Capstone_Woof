# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  $('body').on 'click','.add-pet', ->
    group_id = this.dataset.groupId
    if $(this).text() == 'Add Pet'
      $('#new_pet_card_'+group_id).show()
      $('#collapse_group_'+group_id+'_new_pet').collapse('show')
      $(this).html('Cancel')
    else
      $('#new_pet_card_'+group_id).hide()
      $('#collapse_group_'+group_id+'_new_pet').collapse('hide')
      $(this).html('Add Pet')
  
  $('body').on 'click','.edit-btn', ->
    show_fields = $(this).parent('.pet-show-fields')
    show_fields.toggle()
    show_fields.siblings('.pet-form-fields').toggle()

  $('#sidebarCollapse').on 'click', ->
    $('#sidebar').toggleClass 'active'
    
  $('body').on 'click','.cancel-btn', (e)->
    form_fields = $(this).parent().parent('.pet-form-fields')
    form_fields.toggle()
    form_fields.siblings('.pet-show-fields').toggle()
    e.preventDefault()
    
  bindSelect2Elements() # application.js