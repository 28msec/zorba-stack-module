import module namespace stack = "http://www.zorba-xquery.com/modules/store/data-structures/stack";

stack:create("stack1");
stack:push("stack1", <a/>);
stack:push("stack1", <b/>);
stack:push("stack1", <c/>);
stack:copy("stackcopy", "stack1");
(stack:top("stack1"),
stack:top("stackcopy"))
