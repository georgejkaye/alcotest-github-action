module Make (ToolExtra : Object.T) = struct
  type t = {
    name : string;
    version : string option;
    extra : ToolExtra.t option;
  }
  [@@deriving show, yojson]
end
