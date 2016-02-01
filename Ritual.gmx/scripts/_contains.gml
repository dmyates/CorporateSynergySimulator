#define _contains
/*
Returns true if the given array contains the given value

@param {String|Array|DS_Map} The collection to search
@param {*} The value to look for
@param {Real} [0] The index to begin looking from
@returns {Boolean} True if the collection contains the target, otherwise false

@example
_contains([1, 2, 3], 1);
// => true

_contains([1, 2, 3], 1, 1);
// => false

_contains("hello", "ello");
// => true
*/

var collection = argument[0];
var target = argument[1]
var fromIndex = 0;

if (argument_count == 3) {
    fromIndex = argument[2];
}

if (is_string(collection)) {

    // If it is a string, check to see if the target is in the string.
    return string_count(string(target), collection) > 0;
} else if (is_array(collection)) {

    // If it is an array, check if target exists in the array.
    for (var i = fromIndex; i < _length(collection); i++) {
        if (_typeOf(collection[i]) == _typeOf(target) && collection[i] == target) {
            return true;
        }
    }
    return false;
} else if (is_real(collection)) {
    
    // If it is a real, assume it is a ds ID.
    if (ds_exists(collection, ds_type_map)) {
        var keys = _keys(collection);
        for (var i = fromIndex; i < _length(keys); i++) {
            var thisValue = ds_map_find_value(collection, keys[i])
            if (_typeOf(thisValue) == _typeOf(target) && thisValue == target) {
                return true;
            }
        }
        return false;
    }
}



#define _typeOf
/*
Returns the variable type of the given argument

@param {*} A variable to check the type of
@returns {String} The type of the variable as a human readable string

@example

_typeOf(1);
// => "real"

_typeOf("hello");
// => "string"

var arr;
arr[0] = 1; arr[1] = 2;
_typeOf(arr);
// => "array"

_typeOf(undefined);
// => "undefined";

_typeOf(sprite_get_texture(spr_player, 1));
// => "pointer";
*/

if (is_string(argument0)) {
    return "string";
} else if (is_array(argument0)) {
    return "array";
} else if (is_ptr(argument0)) {
    return "pointer";
} else if (is_undefined(argument0)) {
    return "undefined";
} else if (is_real(argument0)) {
        return "real";
} 



#define _isEqual
/*
Checks if two values are equal, being safe about type and checking first-level
children of ds_lists and ds_maps. Returns false on type inequality rather than
throwing an error.

@param {*} First value to compare
@param {*} Second value to compare
@param {ds_type} [Optional] If specified, assumes this type instead of inferring
                            the type. Only specify this if using _isEqual for a ds
@returns {Boolean} true if the values are equal, false otherwise

@example

_isEqual([1, 2, 3], [1, 2, 3]);
// => true

_isEqual("hello", 1);
// => false

var map = ds_map_create();
ds_map_add(map, 'hello', 6);
ds_map_add(map, 'world', 10);
var map2 = ds_map_create();
ds_map_add(map2, 'hello', 6);
ds_map_add(map2, 'world', 10);
_isEqual(map, map2, ds_type_map);
// => true

*/

var compareA = argument[0];
var compareB = argument[1];
var type;

if (argument_count == 3) {
    type = argument[2];
} else {
    if (_typeOf(compareA) != _typeOf(compareB)) {
        return false;
    } else {
        if (_typeOf(compareA) == "array") {
            if (_length(compareA) != _length(compareB)) {
                return false;
            }
            
            for (var i = 0; i < _length(compareA); i++) {
                if (!_isEqual(compareA[i], compareB[i])) {
                    return false;
                }
            }
            return true;
        } else {
            return compareA == compareB;
        }
    }
}

if (type == ds_type_map) {
    var aKeys = _keys(compareA);
    var bKeys = _keys(compareB);
    if (!_isEqual(aKeys, bKeys)) {
        return false;
    }
    
    for (var i = 0; i < _length(aKeys); i++) {
        if (!_isEqual(ds_map_find_value(compareA, aKeys[i]), ds_map_find_value(compareB, aKeys[i]))) {
            return false;
        }
    }
    
    return true;
} else if (type == ds_type_list) {
    if (!_isEqual(ds_list_size(compareA), ds_list_size(compareB))) {
        return false;
    }
    
    for (var i = 0; i < ds_list_size(compareA); i++) {
        if (!_isEqual(ds_list_find_value(compareA, i), ds_list_find_value(compareB, i))) {
            return false;
        }
    }
    
    return true;
    
}



#define _reduce
/*
Reduces a collection by iterating over it with a function
Provided script should take 2 arguments: total, value
On the first call, total is undefined


@param {Array} The array to reduce
@param {Script} The script to reduce with
@returns {*} The reduced value from the given script

@example
var arr = _arrayOf(1, 2, 3, 4, 5);
_reduce(arr, sum);
// => 15

var arr = _arrayOf('hello', 'world');
_reduce(arr, concat);
// => 'helloworld';
*/

var array = argument[0];
var func = argument[1];

var result = _run(func, undefined, array[0]);

for (var i = 1; i < _length(array); i++) {
    result = _run(func, result, array[i]);
}

return result;



#define _object
/*
Returns a blank object

To use this function, make an object resource called _gdash_object

@param {String} A category to set on this object as the `type` variable
@returns {Instance} A blank object instance

@example
var data = _object('test');
data.hello = 'world';
show_debug_message(data.type);
// => prints "test"
*/
var obj = instance_create(0, 0, _gdash_object);

if (argument_count == 1) {
    obj.type = argument0;
}

return obj;



#define _times
/*
Returns an array of the result of a function run the given number of times

@param {Real} The number of times to execute the function
@param {Script} The script to execute
@returns {Array} An array of the script results

@example
_times(3, returnTheValue5);
// => [5, 5, 5];

*/
var count = argument[0];
var func = argument[1];

var arr;

for (var i = 0; i < count; i++) {
    arr[i] = _run(func, i);
}

return arr;



#define _collect
/*
Returns an array of all objects of the provided type

@param {ObjectType} The object type to collect
@returns {Array} An array of all object IDs of the provided type in the room

@example

_collect(obj_character);
// => [10001, 10002, 10005]
*/
var result;
var i = 0;

with (argument0) {
    result[i] = id;
    i++;
}

return result;



#define _filter
/*
Returns an array where values of the input array are truthy when run through
the provided function.

@param {Array} The array to filter
@param {Script} The script to filter with
@returns {Array} The filtered array

@example
_filter(_arrayOf(0, 1, 2, 3), lessThanTwo)
// => [0, 1]

*/

var array = argument[0];
var func = argument[1];
var result = undefined;
var resultCount = 0;

for (var i = 0; i < _length(array); i++) {
    if (_run(func, array[i])) {
        result[resultCount] = array[i];
        resultCount++;
    }    
}

return result;



#define _concat
/*
Appends the values of one array to another.

@param {Array} The array to append to
@param {Array} The array to append
@returns {Array} The concatenated array

@example
_concat(_arrayOf(0, 1, 2), _arrayOf(3, 4, 5));
// => [0, 1, 2, 3, 4, 5]

*/

var inputArray = argument[0];
var appendArray = argument[1];
var i = _length(inputArray),
var n = 0;

repeat (_length(appendArray)) {
    inputArray[i] = appendArray[n];
    n++;
    i++;
}

return inputArray;



#define _destroy
/*
Destroys the passed in instance

@param {Instance} The instance to destroy

@example
_destroy(obj_enemy);

// Destroy all obj_enemy with no health (hasNoHealth is a script)
_map(_filter(_collect(obj_enemy)), hasNoHealth), _destroy);
*/

with (argument0) {
    instance_destroy();
}



#define _partial
/*
Creates a partial function identifier for use in place of raw scripts
in gdash functions, or with the use of _run.

Partials are to be treated as a data structure, and must be cleaned up
with _free() when they are no longer of use.

@param {Script} The script to create a partial of
@param 1-14 {*} Arguments to bind to the partial
@returns {Real} The partial ID (a ds_map, internally)

@example
// Script: lessThan
return argument1 < argument0

// Meanwhile...
var __lessThanTwo = _partial(lessThan, 2);
__lessThanTwo(1);
// => true

__lessThanTwo(10);
// => false

*/
var func = argument[0];
var args;
for (var i = 1; i < argument_count; i++) {
    args[i - 1] = argument[i];
}

var partial = ds_map_create();
ds_map_add(partial, 'function', func);
ds_map_add(partial, 'args', args);
ds_map_add(partial, 'partial', 'partial');

return partial;



#define _arrayOf
/*
Returns an array of the given arguments.

@param 0-14 {*) Values to put into an array
@returns {Array} An array of the given parameters

@example
_arrayOf(1, 2, 3);
// => [1, 2, 3];

_arrayOf('hello', 'world', 'i', 'am', 'an', 'array');
// => ['hello', 'world', 'i', 'am', 'an', 'array'];
*/

var arr;
for (i = 0; i < argument_count; i++) {
    arr[i] = argument[i];
}

return arr;



#define _run
/*
Executes a script or partial with the provided arguments

@param {Script|Real} The script to run or the ID of the partial to run
@param 1-14 {*} Arguments to pass the script
@returns {*} The return value of the script

@example
_run(_add, 1, 2);
// => 3

var addTwo = _partial(_add, 2);
_run(addTwo, 1);
// => 3
*/

var func = argument[0];
var args;
for (var i = 1; i < argument_count; i++) {
    args[i - 1] = argument[i];
}

// Check if func is a partial (map with 'partial' set to 'partial';
if (ds_exists(func, ds_type_map) && _isEqual(ds_map_find_value(func, 'partial'), 'partial')) {
    var partialId = func;
    func = ds_map_find_value(partialId, 'function');
    args = _concat(ds_map_find_value(partialId, 'args'), args);
}

return _spread(func, args);



#define _push
/*
Adds a value to the end of an array

@param {Array} The array to add the value to
@param {*} The value to add
@returns {Array} The array with the value added

@example
_push(_arrayOf(1, 2), 3);
// => [1, 2, 3]
*/

var arr = argument0;
var addMe = argument1;

arr[_length(arr)] = addMe;
return arr;



#define _map
/*
Iterates over a given collection, running the provided function for each
value in the collection. Returns an array of all function results at each
index.

@param {Array|DS_Map|DS_List} The collection to map
@param {Script} The script to map over the collection
@param {ds_type|String} ["array"] The type of collection. Only provide when using a DS
@returns {Array} An array of all mapped results

@example

var arr;
arr[0] = 1; arr[1] = 2;
_map(arr, doubleValue);
// => [2, 4];

var map = ds_map_create();
ds_map_add(map, 'hello', 6);
ds_map_add(map, 'world', 10);
_map(map, divideByTwo, ds_type_map);
// => [3, 5]
*/

var collection = argument[0];
var func = argument[1];
var type = "array";

if (argument_count == 3) {
    type = argument[2];
}

var resultArray;

if (_isEqual(type, "array")) {
    for (var i = 0; i < _length(collection); i++) {
        resultArray[i] = _run(func, collection[i], i);
    }
    
    return resultArray;
} else if (_isEqual(type, ds_type_map)) {
    var keys = _keys(collection);
    for (var i = 0; i < _length(keys); i++) {
        resultArray[i] = _run(func, ds_map_find_value(collection, keys[i]), keys[i]);
    }
    return resultArray;
} else if (_isEqual(type, ds_type_list)) {
    for (var i = 0; i < _length(collection); i++) {
        resultArray[i] = _run(func, ds_list_find_value(collection, i), i);
    }
    return resultArray;
}




#define _uniq
/*
Returns an array with all duplicate values removed

@param {Array} An array with duplicate values
@returns {Array} An array with the duplicate values removed

@example
_uniq(_arrayOf(1, 1, 2, 3));
// => [1, 2, 3]
*/

var arr = argument0;
var result = undefined;

for (var i = 0; i < _length(arr); i++) {
    if (!_contains(result, arr[i])) {
        result = _push(result, arr[i]);
    }
}

return result;




#define _and
/**
Returns the value of the provided arguments after a boolean and

@param {*} Some first input
@param {*} A value to && the first input with
@returns {Boolean} The value of the provided arguments after an &&

@example
_and(true, true);
// => true

_and(false, true);
// => false

*/
return argument0 && argument1;



#define _find
/*
Iterates over an array, returning the first element that the
given script returns true for.

@param {Array} The array to iterate over
@param {Script} The script to run on the given element
@returns {*} The first element that returns truthy from the script

@example
_find(_arrayOf(0, 1, 2, 3), __equalsThree);
// => 3
*/

for (var i = 0; i < _length(argument0); i++) {
    if (_run(argument1, argument0[i])) {
        return argument0[i];
    }
}



#define _keys
/*
Returns an array contains all keys in a ds_map
Order is not guaranteed due to how ds_maps are stored

@param {DS_Map} The map to get the keys from
@returns {Array} An array of all keys in the map

@example
var map = ds_map_create();
ds_map_add(map, 'hello', 'world');
ds_map_add(map, 'health', 100);

_keys(map);
// => ['hello', 'health']

*/

var map = argument0;
var keys;
keys[0] = ds_map_find_first(map);
var nextKey = ds_map_find_next(map, keys[0]);

while (!is_undefined(nextKey)) {
    keys[_length(keys)] = nextKey;
    nextKey = ds_map_find_next(map, nextKey);
}

return keys;



#define _free
/*
Frees a partial function from memory

@param {Real} The partial ID to free

@example
var __sometihng = _partial(someScript, 1);
__something(2);
_free(__something);

*/
var dsId = argument[0];
var type;

if (argument_count == 1) {
    type = ds_type_map;
} else {
    type = argument[1];
}

if (_isEqual(type, "partial")) {
    type = ds_type_map;
}

switch (type) {
    case ds_type_map:
        ds_map_destroy(dsId);
        break;
    case ds_type_list:
        ds_list_destroy(dsId);
        break;
}



#define _spread
/*
Runs a script with the provided array as arguments
Note: This script is disgusting, but useful.

@param {Script} The script to run
@param {Array} An array to provide as individual arguments
@return {*} The return value of the script

@example
_spread(ds_list_add, _arrayOf(listId, 1, 2, 3, 4));
// => List now contains 1, 2, 3, 4
*/

var func = argument[0];
var args = argument[1];
switch (_length(args)) {
  case 0:
    return script_execute(func);
  case 1:
    return script_execute(func, args[0]);
  case 2:
    return script_execute(func, args[0], args[1]);
  case 3:
    return script_execute(func, args[0], args[1], args[2]);
  case 4:
    return script_execute(func, args[0], args[1], args[2], args[3]);
  case 5:
    return script_execute(func, args[0], args[1], args[2], args[3], args[4]);
  case 6:
    return script_execute(func, args[0], args[1], args[2], args[3], args[4], args[5]);
  case 7:
    return script_execute(func, args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
  case 8:
    return script_execute(func, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
  case 9:
    return script_execute(func, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
  case 10:
    return script_execute(func, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
  case 11:
    return script_execute(func, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10]);
  case 12:
    return script_execute(func, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11]);
  case 13:
    return script_execute(func, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12]);
  case 14:
    return script_execute(func, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13]);
  case 15:
    return script_execute(func, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14]);
}



#define _length
/*
Returns the length of the given array or ds_list

@param {Array|DS_List} The collection to determine the length of
@returns {Real} The length of the collection

@example
_length([1, 2, 3, 4]);
// => 4

_length(some_list_id_of_size_5);
// => 5
*/

if (_typeOf(argument0) == "array") {
    return array_length_1d(argument0);
} else if (_typeOf(argument0) == "real" && ds_exists(argument0, ds_type_list)) {
    return ds_list_size(argument0);
}