xquery version "3.0";

(:
 : Copyright 2006-2012 The FLWOR Foundation.
 :
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 : http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
:)

(:~
 : Implementation of stack for node items, using dynamic collections.<br />
 :
 : @author Daniel Turcanu, Sorin Nasoi
 : @project store/data structures
 :)
module namespace stack = "http://zorba.io/modules/stack";

import module namespace collections-ddl = "http://www.zorba-xquery.com/modules/store/dynamic/collections/ddl";
import module namespace collections-dml = "http://www.zorba-xquery.com/modules/store/dynamic/collections/dml";

declare namespace ann = "http://www.zorba-xquery.com/annotations";
declare namespace ver = "http://www.zorba-xquery.com/options/versioning";
declare option ver:module-version "1.0";

(:~
 : Errors namespace URI.
:)
declare variable $stack:errNS as xs:string := "http://zorba.io/modules/stack";
 
(:~
 : xs:QName with namespace URI="http://www.zorba-xquery.com/modules/store/data-structures/stack" and local name "errNA"
:)
declare variable $stack:errNA as xs:QName := fn:QName($stack:errNS, "stack:errNA");

(:~
 : xs:QName with namespace URI="http://www.zorba-xquery.com/modules/store/data-structures/stack" and local name "errExists"
:)
declare variable $stack:errExists as xs:QName := fn:QName($stack:errNS, "stack:errExists");

(:~
 : <p> Create a stack with this name. If stack exists, an error is raised. </p>
 :
 : @param  $name name of the new stack.
 : @return an empty sequence.
 : @error  stack:errExists if the stack identified by $name already exists.
 :)
declare %ann:sequential function stack:create($name as xs:QName) as empty-sequence()
{
  if(collections-ddl:is-available-collection($name)) then
    fn:error($stack:errExists, "Stack already exists.");
  else
    collections-ddl:create($name);
};

(:~
 : <p> Return the top node in the stack, without removing it. </p>
 :
 : @param   $name name of the stack.
 : @return  the top node, or empty sequence if stack is empty.
 : @example test/Queries/top1.xq
 : @error   stack:errNA if the stack identified by $name does not exist.
 :)
declare function stack:top($name as xs:QName) as node()?
{
  if(not(collections-ddl:is-available-collection($name))) then
    fn:error($stack:errNA, "Stack does not exist.")
  else
    collections-dml:collection($name)[1]
};

(:~
 : <p> Return the top node in the stack, and remove it. </p>
 :
 : @param   $name name of the stack.
 : @return  the top node, or empty sequence if stack is empty.
 : @example test/Queries/pop2.xq
 : @error   stack:errNA if the stack identified by $name does not exist.
 :)
declare %ann:sequential function stack:pop($name as xs:QName) as node()?
{
  if(not(collections-ddl:is-available-collection($name))) then
    fn:error($stack:errNA, "Stack does not exist.")
  else
  {
    variable $topNode := collections-dml:collection($name)[1];
    collections-dml:delete-node-first($name);
    $topNode
  }
};

(:~
 : <p> Add a new node to the stack; the stack will contain a copy of the given node. </p>
 :
 : @param   $name name of the stack.
 : @param   $value the node to be added.
 : @return  an empty sequence.
 : @example test/Queries/push1.xq
 : @error   stack:errNA if the stack identified by $name does not exist.
 :)
declare %ann:sequential function stack:push($name as xs:QName, $value as node()) as empty-sequence()
{
  collections-dml:apply-insert-nodes-first($name, $value);
};

(:~
 : <p> Checks if a stack exists and is empty. </p>
 :
 : @param   $name name of the stack.
 : @return  true if the stack is empty or does not exist.
 : @example test/Queries/empty1.xq
 : @error   stack:errNA if the stack identified by $name does not exist.
 :)
declare function stack:empty($name as xs:QName) as xs:boolean
{
  if(not(collections-ddl:is-available-collection($name))) then
    fn:error($stack:errNA, "Stack does not exist.")
  else
    fn:empty(collections-dml:collection($name))
};

(:~
 : <p> Count of nodes in the stack. </p>
 :
 : @param   $name name of the stack.
 : @return  the amount of nodes.
 : @example test/Queries/size1.xq
 : @error   stack:errNA if the stack identified by $name does not exist.
 :)
declare function stack:size($name as xs:QName) as xs:integer
{
  if(not(collections-ddl:is-available-collection($name))) then
    fn:error($stack:errNA, "Stack does not exist.")
  else
    fn:count(collections-dml:collection($name))
};

(:~
 : <p> Copy all nodes from source stack to a destination stack.
 : If destination stack does not exist, it is created first.
 : If destination stack is not empty, the nodes are appended on top. </p>
 :
 : @param   $destName name of the destination stack.
 : @param   $sourceName name of the source stack.
 : @return  an empty sequence.
 : @example test/Queries/copy1.xq
 :)
declare %ann:sequential function stack:copy($destName as xs:QName, $sourceName as xs:QName) as empty-sequence()
{
  if(fn:not(collections-ddl:is-available-collection($destName))) then
    collections-ddl:create($destName);
  else
    ();
  collections-dml:insert-nodes-first($destName, collections-dml:collection($sourceName));
};
