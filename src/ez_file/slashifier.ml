(**************************************************************************)
(*                                                                        *)
(*   Typerex Libraries                                                    *)
(*                                                                        *)
(*   Copyright 2011-2026 OCamlPro SAS                                     *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

let enabled = ref false
let enable () = enabled := true
let disable () = enabled := false

module type IMPLEM = sig
  val get_dir_separator : unit -> char
  val get_dir_separator_string : unit -> string
  val slashify : string -> string
  val concat : string -> string -> string
  val temp_file : ?temp_dir: string -> string -> string -> string
end

module Unix = struct
  let get_dir_separator () = FileOS.dir_separator
  let get_dir_separator_string () = FileOS.dir_separator_string
  let slashify s = s
  let concat = Filename.concat
  let temp_file = Filename.temp_file
end

module Win32 = struct

  let get_dir_separator () =
    if !enabled then '/'
    else FileOS.dir_separator

  let get_dir_separator_string () =
    if !enabled then "/"
    else FileOS.dir_separator_string

  let slashify s =
    if !enabled && String.contains s '\\' then
      String.map (function '\\' -> '/' | c -> c) s
    else
      s

  let is_dir_sep s i =
    match s.[i] with
    | '/' | '\\' | ':' -> true
    | _ -> false

  let concat dirname filename =
    let l = String.length dirname in
    if l = 0 then
      filename
    else
      if is_dir_sep dirname (l-1)
      then dirname ^ filename
      else Printf.sprintf "%s%c%s" dirname (get_dir_separator ()) filename

  let temp_file ?temp_dir prefix suffix =
    Filename.temp_file ?temp_dir prefix suffix |> slashify

end

module Implem =
  (val (match Sys.os_type with
       | "Win32" | "Cygwin" -> (module Win32: IMPLEM)
       | _ -> (module Unix: IMPLEM)))

include Implem
