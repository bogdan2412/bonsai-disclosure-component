open! Core
open! Import

let component' state ~untoggled_classes ~toggled_classes nodes =
  let classes =
    match (state : Bonsai_toggleable.State.t) with
    | Untoggled -> untoggled_classes
    | Toggled -> toggled_classes
  in
  Vdom.Node.div ~attrs:[ Vdom.Attr.classes classes ] nodes
;;

let component ~untoggled_classes ~toggled_classes nodes =
  let%map.Bonsai_toggleable.Computation state = Bonsai_toggleable.state_machine in
  component' state ~untoggled_classes ~toggled_classes nodes
;;

module Button_and_panel = struct
  type ('a, 'b) t =
    { button : 'a
    ; panel : 'b
    }

  let make ~button ~panel =
    let%map.Bonsai.Computation { value = { button = button_attr, button_nodes; panel }
                               ; toggle
                               ; set_state
                               }
      =
      let%map.Bonsai_toggleable.Computation button = button
      and panel = panel in
      { button; panel }
    in
    let button =
      Vdom.Node.div
        ~attrs:[ button_attr; Vdom.Attr.on_click (fun _ -> toggle ()) ]
        button_nodes
    in
    { Bonsai_toggleable.value = { button; panel }; toggle; set_state }
  ;;

  let create button panel = { button; panel }
  let create_single value = create value value
  let map_both { button; panel } ~f = { button = f button; panel = f panel }

  let map2_both
        { button = button_a; panel = panel_a }
        { button = button_b; panel = panel_b }
        ~f
    =
    { button = f button_a button_b; panel = f panel_a panel_b }
  ;;
end
