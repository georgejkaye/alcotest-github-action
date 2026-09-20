module type Interface = sig
  type t

  val v : t
  val getenv_exn : t -> string -> string
  val getenv : t -> string -> string option
end

module System : Interface = struct
  type t = unit

  let v = ()
  let getenv_exn () = Sys.getenv
  let getenv () = Sys.getenv_opt
end
