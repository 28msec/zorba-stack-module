import module namespace stack = "http://zorba.io/modules/stack";

variable $stName := fn:QName("", "stack1");
(
  stack:create($stName),
  stack:push($stName, <z/>),
  stack:push($stName, <a/>),
  stack:top($stName),
  stack:pop($stName),
  stack:pop($stName),
  stack:top($stName)
)
