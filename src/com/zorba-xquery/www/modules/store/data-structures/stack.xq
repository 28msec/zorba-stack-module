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
 : @project store/data-structures
 :)
module namespace stack = "http://www.zorba-xquery.com/modules/store/data-structures/stack";

import module namespace collections-ddl = "http://www.zorba-xquery.com/modules/store/dynamic/collections/ddl";
import module namespace collections-dml = "http://www.zorba-xquery.com/modules/store/dynamic/collections/dml";

declare namespace ann = "http://www.zorba-xquery.com/annotations";
declare namespace ver = "http://www.zorba-xquery.com/options/versioning";
declare option ver:module-version "1.0";

(:~
 : Return the top node in the stack, without removing it.
 : @param $name QName of the stack
 : @return the top node, or empty sequence if stack with this QName does not exist or is empty
:)
declare function stack:top($name as xs:QName) as node()?
{
  if(collections-ddl:is-available-collection($name) and fn:not(fn:empty(collections-dml:collection($name)))) then
    collections-dml:collection($name)[1]
  else 
    ()
};
                                 
(:~
 : Return the top node in the stack, and remove it.
 : @param $name QName of the stack
 : @return the top node, or empty sequence if stack with this QName does not exist or is empty
:)
declare %ann:sequential function stack:pop($name as xs:QName) as node()?
{
  if(collections-ddl:is-available-collection($name) and fn:not(fn:empty(collections-dml:collection($name)))) then
  {
    variable $top-node := collections-dml:collection($name)[1];
    collections-dml:delete-node-first($name);
    $top-node
  }
  else 
    ()
};

(:~
 : Add a new node to the stack. If the stack does not exist, it is created first.
 : @param $name QName of the stack
 : @param $value the node to be added
:)
declare %ann:sequential function stack:push($name as xs:QName, $value as node())
{
  if(fn:not(collections-ddl:is-available-collection($name))) then
    collections-ddl:create($name);
  else
    ();
  collections-dml:apply-insert-nodes-first($name, $value);
};

(:~
 : Checks if a stack exists and is empty.
 : @param $name QName of the stack
 : @return true is the stack is empty or does not exist
:)
declare function stack:empty($name as xs:QName) as xs:boolean
{
  if(collections-ddl:is-available-collection($name)) then
    fn:empty(collections-dml:collection($name))
  else 
    fn:true()
};

(:~
 : Get the count of nodes in the stack.
 : @param $name QName of the stack
 : @return the count of nodes, or zero if the stack does not exist
:)
declare function stack:size($name as xs:QName) as xs:integer
{
  if(collections-ddl:is-available-collection($name)) then
    fn:count(collections-dml:collection($name))
  else 
    0
};

(:~
 : Remove the stack with all the nodes in it.
 : @param $name QName of the stack
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
 : Copy all nodes from source stack to a destination stack.
 : If destination stack does not exist, it is created first.
 : If destination stack is not empty, the nodes are appended on top.
 : @param $destname QName of the destination stack
 : @param $sourcename QName of the source stack
:)
declare %ann:sequential function stack:copy($destname as xs:QName, $sourcename as xs:QName)
{
  if(fn:not(collections-ddl:is-available-collection($destname))) then
    collections-ddl:create($destname);
  else
    ();
  if(collections-ddl:is-available-collection($sourcename)) then
  {
    collections-dml:insert-nodes-first($destname, collections-dml:collection($sourcename));
  }
  else
    ();
};