import module namespace stack = "http://zorba.io/modules/stack";

variable $stName := fn:QName("", "stack1");
variable $stCopy := fn:QName("", "stackcopy");
stack:create($stName);
stack:push($stName, { "a" : 1 });
stack:push($stName, { "b" : 2.1 });
stack:push($stName, { "c" : jn:null() });
stack:copy($stCopy, $stName);
(stack:top($stName),
stack:top($stCopy))
