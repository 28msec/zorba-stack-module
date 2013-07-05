import module namespace stack = "http://zorba.io/modules/stack";

variable $stName := fn:QName("", "stack1");
(
  stack:create($stName),
  stack:push($stName, { "z" : 9.999 }),
  stack:push($stName, { "a" : jn:null() }),
  stack:top($stName),
  stack:pop($stName),
  stack:pop($stName),
  stack:top($stName)
)
