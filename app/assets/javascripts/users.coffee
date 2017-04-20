# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  newPetForm = (group_number,pet_count)->
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
                  <table class="table table-sm">
                    <tbody>
                        <tr><td><p class="text-muted"><strong>Name</strong></p></td><td><input type="text" class="form-control" placeholer="Coco"></td></tr>
                        <tr><td><p class="text-muted"><strong>ID tag#</strong></p></td><td><input type="number" class="form-control" value="123456789"></td></tr>
                        <tr><td><p class="text-muted"><strong>Breed</strong></p></td><td><select class="form-control"><option></option><option>Shitzu</option></select></td></tr>
                        <tr><td><p class="text-muted"><strong>Weight</strong></p></td><td><select class="form-control"><option></option><option>0 lbs - 10 lbs</option></select></td></tr>
                        <tr><td><p class="text-muted"><strong>Colors</strong></p></td><td><select class="form-control"><option></option><option>white</option></select></td></tr>
                    </tbody>
                  </table>
                  <button class="btn btn-info btn-sm">Save</button>
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
    $('#pet_accordion_'+group_number).append(newPetForm(group_number,pet_count))
    #debugger;
