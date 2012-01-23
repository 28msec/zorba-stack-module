import module namespace stack = "http://www.zorba-xquery.com/modules/store/data-structures/stack";

declare variable $stname as xs:QName := fn:QName("http://stack-example.zorba-xquery.com", "stack1");
declare variable $stcopy as xs:QName := fn:QName("http://stack-example.zorba-xquery.com", "stackcopy");

stack:push($stname, <a/>);
stack:push($stname, <b/>);
stack:push($stname, <c/>);
stack:copy($stcopy, $stname);
(stack:top($stname),
stack:top($stcopy))
