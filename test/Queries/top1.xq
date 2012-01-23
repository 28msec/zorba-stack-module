import module namespace stack = "http://www.zorba-xquery.com/modules/store/data-structures/stack";

declare variable $stname as xs:QName := fn:QName("http://stack-example.zorba-xquery.com", "stack1");

(
stack:push($stname, <z/>),
stack:push($stname, <a/>),
stack:top($stname),
stack:pop($stname),
stack:pop($stname),
stack:top($stname)
)