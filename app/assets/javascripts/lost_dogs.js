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

                /* console.log(document.getElementById("lost_dog_pet_id")[pet_id - 1])
                console.log(document.getElementById("pets"));  */

            }
        }
    });
}

function prefill_dropdowns()
{
    /*console.log(document.getElementById("group_id"));
    console.log(document.getElementById("group_id").length);
    console.log(document.getElementById("group_id")[group_id]);
    console.log(document.getElementById("group_id")[group_id].selected);*/
    document.getElementById("group_id")[group_id].selected = true;
    get_pets_div(group_id, pet_id);
}