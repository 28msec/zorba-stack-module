import module namespace stack = "http://zorba.io/modules/stack";

variable $stName := fn:QName("", "stack1");
stack:create($stName);
stack:push($stName, {"a" : 1});
stack:pop($stName)
