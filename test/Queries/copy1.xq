import module namespace stack = "http://www.zorba-xquery.com/modules/store/data-structures/stack";

variable $stName := fn:QName("", "stack1");
variable $stCopy := fn:QName("", "stackcopy");
stack:create($stName);
stack:push($stName, <a/>);
stack:push($stName, <b/>);
stack:push($stName, <c/>);
stack:copy($stCopy, $stName);
(stack:top($stName),
stack:top($stCopy))
