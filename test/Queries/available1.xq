import module namespace stack = "http://www.zorba-xquery.com/modules/store/data-structures/stack";
import module namespace collections-ddl = "http://www.zorba-xquery.com/modules/store/dynamic/collections/ddl";

variable $name := fn:QName("http://www.zorba-xquery.com/modules/store/dynamic/collections/ddl", "stack12");
variable $stName := fn:QName("", "stack1");
collections-ddl:create($name);

stack:create($stName);
stack:available-stacks()
