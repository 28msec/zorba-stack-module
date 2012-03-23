import module namespace stack = "http://www.zorba-xquery.com/modules/store/data-structures/stack";

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
