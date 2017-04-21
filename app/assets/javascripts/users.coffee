# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  newPetForm = (group_number,pet_count,group_id)->
    html = """
           <div class="card">
              <div class="card-header" role="tab" id="heading_group_#{group_number}_pet_#{pet_count}">
                <h5 class="mb-0">
                  <img class="rounded-circle" src="//placehold.it/50x50" alt="Card image">
                  <a class="collapsed" data-toggle="collapse" data-parent="#pet_accordion_#{group_number}" href="#collapse_group_#{group_number}_pet_#{pet_count}" aria-expanded="false" aria-controls="collapse_group_#{group_number}_pet_#{pet_count}">
                    New Pet
                  </a>
                </h5>
              </div>
              <div id="collapse_group_#{group_number}_pet_#{pet_count}" class="collapse show" role="tabpanel" aria-labelledby="heading_group_#{group_number}_pet_#{pet_count}">
                <div class="card-block">
                  <form class="new_pet" id="new_pet" action="/pets" accept-charset="UTF-8" method="post">
                  <table class="table table-sm">
                    <tbody>
                        <tr><td><p class="text-muted"><strong>Name</strong></p></td><td><input type="text" class="form-control" name="pet[name]" id="pet_name"></td></tr>
                        <tr><td><p class="text-muted"><strong>Breed</strong></p></td><td><select class="form-control" name="pet[breed_id]" id="breed_id"><option value=""></option><option value="229">Mastiff</option></select></td></tr>
                        <tr><td><p class="text-muted"><strong>Weight</strong></p></td><td><select class="form-control" name="pet[weight_id]" id="weight_id"><option value=""></option><option value="7">61 lbs - 70 lbs</option></select></td></tr>
                        <tr><td><p class="text-muted"><strong>Colors</strong></p></td><td><select multiple class="form-control" name="pet[color_ids]" id="color_ids"><option value="6">black</option><option value="1">brown</option><option value="8">white</option></select></td></tr>
                    </tbody>
                  </table>
                  <input type="submit" name="commit" value="Save" class="btn btn-info btn-sm" data-disable-with="Saving..."><input name="utf8" type="hidden" value="✓"><input name="pet[group_id]" type="hidden" value="#{group_id}">
                  </form>
                </div>
              </div>
            </div>
           """
    return html
  
  $('.add-pet').click ->
    #console.log "click test"
    #console.log this
    $('.collapse.show').collapse('hide')
    button = this
    group_number = this.dataset.groupNumber
    pet_count = this.dataset.petCount
    group_id = this.dataset.groupId
    $('#pet_accordion_'+group_number).append(newPetForm(group_number,pet_count,group_id))
    #debugger;
