///values_createguesses(value_number)

with (obj_guess)
    instance_destroy() //get rid of existing choices

choices = ds_list_create()
ds_list_add(choices, our_values[argument0]) //right answer

ds_list_delete(values, ds_list_find_index(values, our_values[argument0]))
ds_list_shuffle(values)
repeat (2)
{
    ds_list_add(choices, values[| 0])
    ds_list_delete(values, 0)
}

ds_list_shuffle(choices)

for (i = 0; i < 3; i += 1)
    with (instance_create(room_width/2, room_height * (0.3+(i*0.2)), obj_guess))
        value = other.choices[| other.i]
    
ds_list_destroy(choices)
