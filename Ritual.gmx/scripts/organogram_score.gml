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

rules_list = ds_list_create()
ds_list_add(rules_list, rule[0], rule[1], rule[2])

for (o = 0; o < ds_list_size(order_list); o += 1)
{
    for (r = 0; r < ds_list_size(rules_list); r += 1)
    {
        if _contains(order_list[| o], rules_list[| r])
           ds_list_replace(order_list, o, rules_list[| r])
    }
}

//Prune rules list
for (r = 0; r < ds_list_size(rules_list); r += 1)
{
    if _contains(order_list, rules_list[| r])
       continue
       
    ds_list_delete(rules_list, r)
}
           
ra = _map(rules_list, return_self, ds_type_list)
oa = _map(order_list, return_self, ds_type_list)

//See if we won or lost
state = 2

if _isEqual(_uniq(_map(rules_list, return_self, ds_type_list)),_uniq(_map(order_list, return_self, ds_type_list)))
   state = 1

ds_list_destroy(rules_list)
ds_list_destroy(order_list)
