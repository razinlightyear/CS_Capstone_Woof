function get_pets_div(group_id, pet_id)
{

    jQuery.ajax({
        // changed here
        url: '/lost_dogs/get_pets',
        type: 'GET',
        data: {'group_id': group_id},
        dataType: 'html',
        success: function(data){
            jQuery('#pets').html(data);

            if(typeof pet_id!= 'undefined')
            {
                $('#lost_dog_pet_id').val(pet_id).attr('selected', true);
            }
        }
    });
}

function prefill_dropdowns()
{
    $('#group_id').val(group_id).attr('selected', true);
    get_pets_div(group_id, pet_id);
}