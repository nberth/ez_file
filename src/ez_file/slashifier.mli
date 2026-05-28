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

val enable : unit -> unit
val disable : unit -> unit
val get_dir_separator : unit -> char
val get_dir_separator_string : unit -> string
val slashify : string -> string
val concat : string -> string -> string
val temp_file : ?temp_dir: string -> string -> string -> string
