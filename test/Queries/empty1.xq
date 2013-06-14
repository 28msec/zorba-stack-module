import module namespace stack = "http://zorba.io/modules/stack";

variable $stName := fn:QName("", "stack1");
(
  stack:create($stName),
  stack:push($stName, <a/>),
  stack:top($stName),
  stack:empty($stName),
  stack:pop($stName),
  stack:top($stName),
  stack:empty($stName)
)
