import module namespace stack = "http://www.zorba-xquery.com/modules/store/data-structures/stack";

(
stack:create("stack1"),
stack:push("stack1", <z/>),
stack:push("stack1", <a/>),
stack:create("stack1"),
stack:top("stack1")
)