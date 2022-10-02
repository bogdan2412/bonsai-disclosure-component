open! Core
open! Import

(** A component that can be toggled between two states. *)
val component
  :  untoggled_classes:string list
  -> toggled_classes:string list
  -> Vdom.Node.t list
  -> Vdom.Node.t Bonsai_toggleable.t Bonsai.Computation.t

(** A virtual DOM node that represents a component in the given state.contents

    [component] is the obvious composition of
    [Bonsai_toggleable.state_machine] and [component']. *)
val component'
  :  Bonsai_toggleable.State.t
  -> untoggled_classes:string list
  -> toggled_classes:string list
  -> Vdom.Node.t list
  -> Vdom.Node.t

module Button_and_panel : sig
  type ('a, 'b) t =
    { button : 'a
    ; panel : 'b
    }

  val make
    :  button:(Vdom.Attr.t * Vdom.Node.t list) Bonsai_toggleable.t Bonsai.Computation.t
    -> panel:Vdom.Node.t list Bonsai_toggleable.t Bonsai.Computation.t
    -> (Vdom.Node.t, Vdom.Node.t list) t Bonsai_toggleable.t Bonsai.Computation.t

  val create : 'a -> 'b -> ('a, 'b) t
  val create_single : 'a -> ('a, 'a) t
  val map_both : ('a, 'a) t -> f:('a -> 'b) -> ('b, 'b) t
  val map2_both : ('a, 'a) t -> ('b, 'b) t -> f:('a -> 'b -> 'c) -> ('c, 'c) t
end
