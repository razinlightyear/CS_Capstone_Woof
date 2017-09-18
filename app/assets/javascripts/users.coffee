# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  $('body').on 'click','.add-pet', ->
    group_id = this.dataset.groupId
    $('#new_pet_card_'+group_id).show()
    $('#collapse_group_'+group_id+'_new_pet').collapse('show')
  
  $('body').on 'click','.edit-btn', ->
    show_fields = $(this).parent('.pet-show-fields')
    show_fields.toggle()
    show_fields.siblings('.pet-form-fields').toggle()
    
  $('body').on 'click','.cancel-btn', (e)->
    form_fields = $(this).parent().parent('.pet-form-fields')
    form_fields.toggle()
    form_fields.siblings('.pet-show-fields').toggle()
    e.preventDefault()
    
  $('.breed-selector').select2
    placeholder: 'Select breed'
    allowClear: true
    theme: 'bootstrap'
    ajax: {
      url: '/breeds/find'
      data: (params) ->
        {
          name: params.term
        }
      dataType: 'json'
      delay: 500
      processResults: (data, params) ->
        {
          results: _.map(data, (el) ->
            {
              id: el.id
              name: el.name
            }
          )
        }
      cache: true
    }
    escapeMarkup: (markup) -> markup
    minimumInputLength: 2 # they should type at least 2 symbols
    templateResult: (item) -> item.name # defines the look of the options displayed in dropdown.
    templateSelection: (item) -> item.name || item.text # defines the look of the selected option.
    
    
  $('.colors-selector').select2
    placeholder: 'Select Colors'
    allowClear: true
    theme: 'bootstrap'
    ajax: {
      url: '/colors/find'
      data: (params) ->
        {
          name: params.term
        }
      dataType: 'json'
      delay: 500
      processResults: (data, params) ->
        {
          results: _.map(data, (el) ->
            {
              id: el.id
              name: el.name
            }
          )
        }
      cache: true
    }
    escapeMarkup: (markup) -> markup
    minimumInputLength: 2 # they should type at least 2 symbols
    templateResult: (item) -> item.name # defines the look of the options displayed in dropdown.
    templateSelection: (item) -> item.name || item.text # defines the look of the selected option.
    
  $('.weight-selector').select2
    placeholder: 'Select weight range'
    allowClear: true
    theme: 'bootstrap'
