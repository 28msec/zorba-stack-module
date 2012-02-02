import module namespace stack = "http://www.zorba-xquery.com/modules/store/data-structures/stack";
import module namespace collections-ddl = "http://www.zorba-xquery.com/modules/store/dynamic/collections/ddl";

collections-ddl:create(fn:QName("http://www.zorba-xquery.com/modules/store/dynamic/collections/ddl", "stack12"));

stack:create("stack1");
stack:available-stacks()
