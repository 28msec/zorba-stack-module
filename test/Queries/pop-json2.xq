import module namespace stack = "http://zorba.io/modules/stack";

variable $stName := fn:QName("", "stack1");
stack:create($stName);
stack:push($stName, { "b" : 1 });
stack:push($stName, { "a" : 0 });
stack:pop($stName)
