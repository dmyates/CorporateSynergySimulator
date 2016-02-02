///organogram_score()

ot_list = ds_list_create()

//Collect and rank all organotiles

var i, j, k;

for (i = 0; i < instance_count; i += 1)
{
    with (instance_id[i])
    {
        if (object_index == obj_organotile)
        {
           //insertion sort to figure out where it goes
           pos = 0
           
           for (j = ds_list_size(other.ot_list)-1; j > -1; j -= 1)
           {                    
               inst = other.ot_list[| j]
                    
               if y < inst.y
                   continue
               else
               {
                   pos = j + 1
                   break
               }
           }           
           
           //then do the insertion
           ds_list_insert(other.ot_list, pos, id)   
        }     
    }
}

order_list = ds_list_create()

//Make a string & list of the order
for (k = 0; k < ds_list_size(ot_list); k += 1)
{
    order_str += ot_list[| k].label + "#"    
    ds_list_add(order_list, ot_list[| k].label)
}

ds_list_destroy(ot_list)

//Check order against rules

var __nth_word

__nth_word = _partial(string_word_pos, rulenum) //return rulenum-th word

order_rules = _map(order_list, __nth_word, ds_type_list)

_free(__nth_word)

ds_list_destroy(order_list)

//See if we won or lost
state = 2

if _isEqual(rules, order_rules)
   state = 1
