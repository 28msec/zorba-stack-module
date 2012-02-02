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
 : Implementation of stack for node items, using collections data structures.
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
 : URI for all collections QNames. Stack names are combined with this URI to construct
 : QNames used by collection api. <br/>
 : The URI is "http://www.zorba-xquery.com/modules/store/data-structures/stack".
 :)
declare variable $stack:global-uri := "http://www.zorba-xquery.com/modules/store/data-structures/stack";

(:~
 : Create a stack with this name. If stack exists, it is deleted first.
 : @param $name string name of the new stack
:)
declare %ann:sequential function stack:create($name as xs:string)
{
  variable $stname := fn:QName($stack:global-uri, $name);
  stack:delete($name);
  collections-ddl:create($stname);
};

(:~
 : Return a list of string names for available stacks.
 : @return the list of created stack names
 : @example test/Queries/available1.xq
:)
declare function stack:available-stacks() as xs:string*
{
  for $coll-qname in collections-ddl:available-collections()
  where fn:namespace-uri-from-QName($coll-qname) eq $stack:global-uri
  return fn:local-name-from-QName($coll-qname)
};

(:~
 : Return the top node in the stack, without removing it.
 : @param $name string name of the stack
 : @return the top node, or empty sequence if stack is empty
 : @example test/Queries/top1.xq
:)
declare function stack:top($name as xs:string) as node()?
{
  let $stname := fn:QName($stack:global-uri, $name)
  let $stack-content := collections-dml:collection($stname)
  return
      if(fn:not(fn:empty($stack-content))) then
        $stack-content[1]
      else 
        ()
};
                                 
(:~
 : Return the top node in the stack, and remove it.
 : @param $name string name of the stack
 : @return the top node, or empty sequence if stack is empty
 : @example test/Queries/pop2.xq
:)
declare %ann:sequential function stack:pop($name as xs:string) as node()?
{
  let $stname := fn:QName($stack:global-uri, $name)
  let $stack-content := collections-dml:collection($stname)
  return 
      if(fn:not(fn:empty($stack-content))) then
      {
        variable $top-node := $stack-content[1];
        collections-dml:delete-node-first($stname);
        $top-node
      }
      else 
        ()
};

(:~
 : Add a new node to the stack.
 : @param $name string name of the stack
 : @param $value the node to be added
 : @example test/Queries/push1.xq
:)
declare %ann:sequential function stack:push($name as xs:string, $value as node())
{
  variable $stname := fn:QName($stack:global-uri, $name);
  collections-dml:apply-insert-nodes-first($stname, $value);
};

(:~
 : Checks if a stack exists and is empty.
 : @param $name string name of the stack
 : @return true is the stack is empty or does not exist
 : @example test/Queries/empty1.xq
:)
declare function stack:empty($name as xs:string) as xs:boolean
{
  let $stname := fn:QName($stack:global-uri, $name)
  return
      if(collections-ddl:is-available-collection($stname)) then
        fn:empty(collections-dml:collection($stname))
      else 
        fn:true()
};

(:~
 : Get the count of nodes in the stack.
 : @param $name string name of the stack
 : @return the count of nodes
 : @example test/Queries/size1.xq
:)
declare function stack:size($name as xs:string) as xs:integer
{
  let $stname := fn:QName($stack:global-uri, $name)
  return
    fn:count(collections-dml:collection($stname))
};

(:~
 : Remove the stack with all the nodes in it.
 : @param $name string name of the stack
 : @example test/Queries/delete1.xq
:)
declare %ann:sequential function stack:delete($name as xs:string)
{
  let $stname := fn:QName($stack:global-uri, $name)
  return
      if(collections-ddl:is-available-collection($stname)) then
      {
        collections-dml:delete-nodes-first($stname, stack:size($name));
        collections-ddl:delete($stname);
        ()
      }
      else
        ()
};

(:~
 : Copy all nodes from source stack to a destination stack.
 : If destination stack does not exist, it is created first.
 : If destination stack is not empty, the nodes are appended on top.
 : @param $destname string name of the destination stack
 : @param $sourcename string name of the source stack
 : @example test/Queries/copy1.xq
:)
declare %ann:sequential function stack:copy($destname as xs:string, $sourcename as xs:string)
{
  variable $destqname := fn:QName($stack:global-uri, $destname);
  if(fn:not(collections-ddl:is-available-collection($destqname))) then
    collections-ddl:create($destqname);
  else
    ();
  variable $sourceqname := fn:QName($stack:global-uri, $sourcename);
  collections-dml:insert-nodes-first($destqname, collections-dml:collection($sourceqname));
};
