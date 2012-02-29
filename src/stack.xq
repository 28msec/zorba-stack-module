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
 : Implementation of stack for node items, using collections data structures.<br />
 : Stacks are created at first node insert.
 :
 : @author Daniel Turcanu
 : @project store/data structures
 :)
module namespace stack = "http://www.zorba-xquery.com/modules/store/data-structures/stack";

import module namespace collections-ddl = "http://www.zorba-xquery.com/modules/store/dynamic/collections/ddl";
import module namespace collections-dml = "http://www.zorba-xquery.com/modules/store/dynamic/collections/dml";

declare namespace ann = "http://www.zorba-xquery.com/annotations";
declare namespace ver = "http://www.zorba-xquery.com/options/versioning";
declare option ver:module-version "1.0";

(:~
 : Create a stack with this name. <br /> If stack exists, it is deleted first.
 : @param $name name of the new stack.
:)
declare %ann:sequential function stack:create($name as xs:QName)
{
  stack:delete($name);
  collections-ddl:create($name);
};

(:~
 : Return a list of names for available stacks.
 : @return the list of created stack names.
 : @example test/Queries/available1.xq
:)
declare function stack:available-stacks() as xs:QName*
{
  for $collQName in collections-ddl:available-collections()
  return $collQName
};

(:~
 : Return the top node in the stack, without removing it.
 : @param $name name of the stack.
 : @return the top node, or empty sequence if stack is empty.
 : @example test/Queries/top1.xq
:)
declare function stack:top($name as xs:QName) as node()?
{
  let $stackContent := collections-dml:collection($name)
  return
    if(fn:not(fn:empty($stackContent))) then
      $stackContent[1]
    else 
      ()
};
                                 
(:~
 : Return the top node in the stack, and remove it.
 : @param $name name of the stack.
 : @return the top node, or empty sequence if stack is empty.
 : @example test/Queries/pop2.xq
:)
declare %ann:sequential function stack:pop($name as xs:QName) as node()?
{
  let $stackContent := collections-dml:collection($name)
  return 
    if(fn:not(fn:empty($stackContent))) then
    {
      variable $topNode := $stackContent[1];
      collections-dml:delete-node-first($name);
      $topNode
    }
    else 
      ()
};

(:~
 : Add a new node to the stack.
 : @param $name name of the stack.
 : @param $value the node to be added.
 : @example test/Queries/push1.xq
:)
declare %ann:sequential function stack:push($name as xs:QName, $value as node())
{
  collections-dml:apply-insert-nodes-first($name, $value);
};

(:~
 : Checks if a stack exists and is empty.
 : @param $name name of the stack.
 : @return true is the stack is empty or does not exist.
 : @example test/Queries/empty1.xq
:)
declare function stack:empty($name as xs:QName) as xs:boolean
{
  if(collections-ddl:is-available-collection($name)) then
    fn:empty(collections-dml:collection($name))
  else 
    fn:true()
};

(:~
 : Count of nodes in the stack.
 : @param $name name of the stack.
 : @return the count of nodes.
 : @example test/Queries/size1.xq
:)
declare function stack:size($name as xs:QName) as xs:integer
{
  fn:count(collections-dml:collection($name))
};

(:~
 : Remove the stack with all the nodes in it.
 : @param $name name of the stack.
 : @example test/Queries/delete1.xq
:)
declare %ann:sequential function stack:delete($name as xs:QName)
{
  if(collections-ddl:is-available-collection($name)) then
  {
    collections-dml:delete-nodes-first($name, stack:size($name));
    collections-ddl:delete($name);
    ()
  }
  else
    ()
};

(:~
 : Copy all nodes from source stack to a destination stack.<br />
 : If destination stack does not exist, it is created first.<br />
 : If destination stack is not empty, the nodes are appended on top.
 : @param $destName name of the destination stack.
 : @param $sourceName name of the source stack.
 : @example test/Queries/copy1.xq
:)
declare %ann:sequential function stack:copy($destName as xs:QName, $sourceName as xs:QName)
{
  if(fn:not(collections-ddl:is-available-collection($destName))) then
    collections-ddl:create($destName);
  else
    ();
  collections-dml:insert-nodes-first($destName, collections-dml:collection($sourceName));
};
