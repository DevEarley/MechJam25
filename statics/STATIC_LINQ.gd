class_name LINQ;

static func First(arr:Array,_callable:Callable):
	for obj in arr:
		if(_callable.call(obj) == true):
			return obj;

static func Count(arr:Array,_callable:Callable):
	return arr.filter(_callable).size()
