/* Copyright (C) 2017 Hongbo Zhang, Authors of ReScript
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. */
type opt<'a> = Js_undefined.t<'a>

type container<'hash, 'eq, 'c> = {
  mutable size: int /* number of entries */,
  mutable buckets: array<opt<'c>> /* the buckets */,
  hash: 'hash,
  eq: 'eq,
}

module A = Belt_Array
external toOpt: opt<'a> => option<'a> = "#undefined_to_opt"
external return: 'a => opt<'a> = "%identity"

let emptyOpt = Js_undefined.empty
let rec power_2_above = (x, n) =>
  if x >= n {
    x
  } else if x * 2 < x {
    x /* overflow */
  } else {
    power_2_above(x * 2, n)
  }

let make = (~hash, ~eq, ~hintSize) => {
  let s = power_2_above(16, hintSize)
  {
    size: 0,
    buckets: A.makeUninitialized(s),
    hash,
    eq,
  }
}

let clear = h => {
  h.size = 0
  let h_buckets = h.buckets
  let len = A.length(h_buckets)
  for i in 0 to len - 1 {
    A.setUnsafe(h_buckets, i, emptyOpt)
  }
}

let isEmpty = h => h.size == 0
