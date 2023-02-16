open OkmlType

(*
 * Constructors
 *)

let color ?(a=255) ~r ~g ~b () = { a ; r ; g ; b }

let string_of_color c =
  Printf.sprintf "%02x%02x%02x%02x" c.a c.r c.g c.b

let default_bg_color = color ~r:255 ~g:255 ~b:255 ()
let default_text_color = color ~r:0 ~g:0 ~b:0 ()

let balloon_style ?id ?(bg_color=default_bg_color) ?(text_color=default_text_color) ?(display_mode=Default) text =
  BalloonStyle.{ id ; bg_color ; text_color ; text ; display_mode }

let camera ?id ?time_primitive ?(longitude=0.) ?(latitude=0.) ?(altitude=0.) ?(heading=0.) ?(tilt=0.) ?(roll=0.) ?(altitude_mode=ClampToGround) () =
  Camera.{ id ; time_primitive ; longitude ; latitude ; altitude ; heading ;
           tilt ; roll ; altitude_mode }

let feature_params ?id ~name ?(visibility=true) ?(open_=false) ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?(style_selectors=[]) ?region () =
  { id ; name ; visibility ; open_ ; address ; phone_number ; snippet ;
    description ; abstract_view ; time_primitive ; style_url ; style_selectors ;
    region }

let document ?id ~name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region schemas features =
  { feature =
      feature_params ?id ~name ?visibility ?open_ ?address
                     ?phone_number ?snippet ?description ?abstract_view
                     ?time_primitive ?style_url ?style_selectors ?region () ;
    schemas ; features }

let folder ?id ~name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region features =
  { feature =
      feature_params ?id ~name ?visibility ?open_ ?address
                     ?phone_number ?snippet ?description ?abstract_view
                     ?time_primitive ?style_url ?style_selectors ?region () ;
    features }

let overlay_params ?id ~name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region ?(color=color ~r:255 ~g:255 ~b:255 ()) ?(draw_order=0) ~icon =
  { feature =
      feature_params ?id ~name ?visibility ?open_ ?address
                     ?phone_number ?snippet ?description ?abstract_view
                     ?time_primitive ?style_url ?style_selectors ?region () ;
    color ; draw_order ; icon }

let lat_lon_box ?(north=0.) ?(south=0.) ?(east=0.) ?(west=0.) ?(rotation=0.) () =
  { north ; south ; east ; west ; rotation }

let ground_overlay ?id ~name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region ?color ?draw_order ~icon ?(altitude=0.) ?(altitude_mode=ClampToGround) ?lat_lon_box () =
  GroundOverlay.{
    overlay =
      overlay_params ?id ~name ?visibility ?open_ ?address ?phone_number
                     ?snippet ?description ?abstract_view ?time_primitive
                     ?style_url ?style_selectors ?region ?color ?draw_order
                     ~icon ;
    altitude ; altitude_mode ; lat_lon_box }

let icon ?id ~href ?(x=0) ?(y=0) ?(w= -1) ?(h= -1) ?(refresh_mode=OnChange) ?(refresh_interval=4.) ?(view_refresh_mode=Never) ?(view_refresh_time=4.) ?(view_bound_scale=1.) ?view_format ?http_query () =
  Icon.{
    id ; href ; x ; y ; w ; h ; refresh_mode ; refresh_interval ;
    view_refresh_mode ; view_refresh_time ; view_bound_scale ; view_format ;
    http_query }

let color_style ?id ?(color=default_bg_color) ?(color_mode=Normal) () =
  ColorStyle.{ id ; color ; color_mode }

let icon_style ?id ?color ?color_mode ?(scale=1.) ?(heading=0.) ?icon ?hot_spot () =
  IconStyle.{
    color_style = color_style ?id ?color ?color_mode () ;
    scale ; heading ; icon ; hot_spot }

let kml ?hint ?feature ?network_link_control () =
  { hint ; feature ; network_link_control }

let label_style ?id ?color ?color_mode ?(scale=1.) () =
  LabelStyle.{
    color_style = color_style ?id ?color ?color_mode () ; scale }

let linear_ring ?id ?(extrude=false) ?(tesselate=false) ?(altitude_mode=ClampToGround) coordinates =
  LinearRing.{ id ; extrude ; tesselate ; altitude_mode ; coordinates }

let line_string ?id ?(extrude=false) ?(tesselate=false) ?(altitude_mode=ClampToGround) ?(draw_order=0) coordinates =
  LineString.{
    id ; extrude ; tesselate ; altitude_mode ; draw_order ; coordinates }

let line_style ?id ?color ?color_mode ?(width=1.) () =
  LineStyle.{ color_style = color_style ?id ?color ?color_mode () ; width }

let link ?id ?href ?(refresh_mode=OnChange) ?(refresh_interval=4.) ?(view_refresh_mode=Never) ?(view_refresh_time=4.) ?(view_bound_scale=1.) ?view_format ?http_query () =
  Link.{
    id ; href ; refresh_mode ; refresh_interval ; view_refresh_mode ;
    view_refresh_time ; view_bound_scale ; view_format ; http_query }

let list_style ?id ?(list_item_type=Check) ?(bg_color=default_bg_color) item_icons =
  ListStyle.{ id ; list_item_type ; bg_color ; item_icons }

let look_at ?id ?time_primitive ?(longitude=0.) ?(latitude=0.) ?(altitude=0.) ?(heading=0.) ?(tilt=0.) ?(altitude_mode=ClampToGround) ~range =
  LookAt.{
    id ; time_primitive ; longitude ; latitude ; altitude ; heading ; tilt ;
    range ; altitude_mode }

let orientation ?(heading=0.) ?(tilt=0.) ?(roll=0.) () =
  Orientation.{ heading ; tilt ; roll }

let location ?(altitude=0.) ~longitude ~latitude () =
  Location.{ longitude ; latitude ; altitude }

let scale ?(x=1.) ?(y=1.) ?(z=1.) () =
  Scale.{ x ; y ; z }

let model ?id ?(altitude_mode=ClampToGround) ?(location=location ~longitude:0. ~latitude:0. ()) ?(orientation=orientation ()) ?(scale=scale()) ~link ~resource_map =
  Model.{
    id ; altitude_mode ; location ; orientation ; scale ; link ;
    resource_map }

let multi_geometry ?id elements =
  MultiGeometry.{ id ; elements }

let network_link ?id ~name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region ?(refresh_visibility=false) ?(fly_to_view=false) ~link =
  NetworkLink.{
    feature =
      feature_params ?id ~name ?visibility ?open_ ?address
                     ?phone_number ?snippet ?description ?abstract_view
                     ?time_primitive ?style_url ?style_selectors ?region () ;
    refresh_visibility ; fly_to_view ; link }

let network_link_control ?(min_refresh_period=0.) ?(max_session_length= ~-.1.) ?cookie ?message ?link_name ?link_description ?link_snippet ?expires ?update ?abstract_view () =
  NetworkLinkControl.{
    min_refresh_period ; max_session_length ; cookie ; message ; link_name ;
    link_description ; link_snippet ; expires ; update ; abstract_view }

let view_volume ?(left_fov=0.) ?(right_fov=0.) ?(bottom_fov=0.) ?(top_fov=0.) ?(near=0.) () =
  { left_fov ; right_fov ; bottom_fov ; top_fov ; near }

let photo_overlay ?id ~name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region ?color ?draw_order ~icon ?(rotation=0.) ?(view_volume=view_volume ()) ?image_pyramid ?(shape=Rectangle) ~point =
  PhotoOverlay.{
    overlay =
      overlay_params ?id ~name ?visibility ?open_ ?address ?phone_number
                     ?snippet ?description ?abstract_view ?time_primitive
                     ?style_url ?style_selectors ?region ?color ?draw_order
                     ~icon ;
    rotation ; view_volume ; image_pyramid ; point ; shape }

let placemark ?id ~name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region geometries =
  Placemark.{
    feature =
      feature_params ?id ~name ?visibility ?open_ ?address
                     ?phone_number ?snippet ?description ?abstract_view
                     ?time_primitive ?style_url ?style_selectors ?region () ;
    geometries }

let point ?id ?(extrude=false) ?(altitude_mode=ClampToGround) coordinates =
  Point.{ id ; extrude ; altitude_mode ; coordinates }

let polygon ?id ?(extrude=false) ?(tessellate=false) ?(altitude_mode=ClampToGround) ~outer_boundary_is ~inner_boundary_is =
  Polygon.{
    id ; extrude ; tessellate ; altitude_mode ; outer_boundary_is ;
    inner_boundary_is }

let poly_style ?id ?color ?color_mode ?(fill=true) ?(outline=true) () =
  PolyStyle.{
    color_style = color_style ?id ?color ?color_mode () ; fill ; outline }

let lat_lon_alt_box ~north ~south ~east ~west ?(min_altitude=0.) ?(max_altitude=0.) ?(altitude_mode=ClampToGround) () =
  { north ; south ; east ; west ; min_altitude ; max_altitude ; altitude_mode }

let lod ?(min_lod_pixels=0.) ?(max_lod_pixels=1.) ?(min_fade_extent=0.) ?(max_fade_extent=0.) () =
  { min_lod_pixels ; max_lod_pixels ; min_fade_extent ; max_fade_extent }

let region ?id ~lat_lon_alt_box ~lod =
  Region.{ id ; lat_lon_alt_box ; lod }

let simple_field ?(display_name) ~type_ ~name =
  { type_ ; name ; display_name }

let schema ~id ?name simple_fields =
  Schema.{ id ; name ; simple_fields }

let screen_overlay ?id ~name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region ?color ?draw_order ~icon ~overlay_xy ~screen_xy ~rotation_xy ?(rotation=0.) ~size =
  ScreenOverlay.{
    overlay =
      overlay_params ?id ~name ?visibility ?open_ ?address ?phone_number
                     ?snippet ?description ?abstract_view ?time_primitive
                     ?style_url ?style_selectors ?region ?color ?draw_order
                     ~icon ;
    overlay_xy ; screen_xy ; rotation_xy ; size ; rotation }

let style ?id ?icon_style ?label_style ?line_style ?poly_style ?balloon_style ?list_style () =
  { id ; icon_style ; label_style ; line_style ; poly_style ; balloon_style ;
    list_style }

let style_map_pair_style ?id style =
  { id ; style }

let style_map ?id ?normal_pair ?highlighted_pair () =
  { id ; normal_pair ; highlighted_pair }

let time ?(zone=UTC) hour min sec =
  { hour ; min ; sec ; zone }

let date_time ?time year month day =
  { year ; month ; day ; time }

let time_span ?id ?begin_ ?end_ () =
  TimeSpan.{ id ; begin_ ; end_ }

let time_stamp ?id when_ =
  TimeStamp.{ id ; when_ }

let update changes =
  { changes }

let angle_90 v =
  (* First move [v] to -180..180: *)
  let v = mod_float v 180. in
  (* Then check it: *)
  if v < ~-.90. || v > 90. then invalid_arg "angle_90" ;
  v

(*$= angle_90 & ~printer:string_of_float
  0. (angle_90 0.)
  80. (angle_90 80.)
  30. (angle_90 (30. +. 360.))
  ~-.80. (angle_90 (~-.80. -. 360.))
*)

let clamp mi ma v =
  if v < mi then mi else
  if v > ma then ma else
  v

let angle_pos_90 v =
  (* First move [v] to -180..180: *)
  let v = mod_float v 180. in
  (* Then clamp it: *)
  clamp 0. 90. v

let angle_180 v =
  mod_float v 180.

let angle_360 v =
  mod_float v 360.

let angle_pos_180 v =
  let v = mod_float v 180. in
  clamp 0. 180. v

(*
 * Pretty Printing
 *)

open Xml

module Xml : sig
  val of_kml : kml -> xml
end =
struct
  let xmlns = "http://www.opengis.net/kml/2.2"

  let add_xml_opt v to_xml lst =
    match v with
    | None -> lst
    | Some v -> to_xml v :: lst

  let add_xml ?if_not v to_xml lst =
    match if_not with
    | Some v' when v = v' -> lst
    | _ -> to_xml v :: lst

  let of_object name id_opt ?(attr=[]) items =
    let attr =
      match id_opt with
      | None -> attr
      | Some id -> ("id", id) :: attr in
    Element (name, attr, items)

  let of_string name ?(attr=[]) s =
    Element (name, attr, [ PCData s ])

  let of_bool name ?attr b =
    of_string name ?attr (if b then "1" else "0")

  let of_float name ?attr v =
    of_string name ?attr (string_of_float v)

  let of_int name ?attr v =
    of_string name ?attr (string_of_int v)

  let of_altitude_mode mode =
    let s =
      match mode with
      | ClampToGround -> "clampToGround"
      | RelativeToGround -> "relativeToGround"
      | Absolute -> "absolute" in
    of_string "altitudeMode" s

  let string_of_datetime d =
    (Printf.sprintf "%04d-%02d-%02d" d.year d.month d.day) ^
    match d.time with
    | None -> ""
    | Some { hour ; min ; sec ; zone = UTC } ->
        Printf.sprintf "T%02d:%02d:%02.6g" hour min sec
    | Some { hour ; min ; sec ; zone = Offset (oh, om) } ->
        Printf.sprintf "T%02d:%02d:%02.6g%+02d:%02d" hour min sec oh om

  let of_datetime name ?(attr=[]) d =
    Element (name, attr, [ PCData (string_of_datetime d) ])

  let of_timespan t =
    add_xml_opt t.TimeSpan.begin_ (of_datetime "begin") [] |>
    add_xml_opt t.end_ (of_datetime "end") |>
    of_object "TimeSpan" t.id

  let of_timestamp t =
    let s =
      match t.TimeStamp.when_ with
      | When.GYear y -> Printf.sprintf "%04d" y
      | GYearMonth (y, m) -> Printf.sprintf "%04d-%02d" y m
      | DateTime d -> string_of_datetime d
    in
    of_object "TimeStamp" t.id [ of_string "when" s ]

  let of_time_primitive = function
    | TimeSpan t -> of_timespan t
    | TimeStamp t -> of_timestamp t

  let of_lookat l =
    add_xml_opt l.LookAt.time_primitive of_time_primitive [] |>
    add_xml ~if_not:0. l.longitude (of_float "longitude") |>
    add_xml ~if_not:0. l.latitude (of_float "latitude") |>
    add_xml ~if_not:0. l.altitude (of_float "altitude") |>
    add_xml ~if_not:0. l.heading (of_float "heading") |>
    add_xml ~if_not:0. l.tilt (of_float "tilt") |>
    add_xml l.range (of_float "range") |>
    add_xml ~if_not:ClampToGround l.altitude_mode of_altitude_mode |>
    of_object "LookAt" l.id

  let of_camera c =
    add_xml_opt c.Camera.time_primitive of_time_primitive [] |>
    add_xml ~if_not:0. c.longitude (of_float "longitude") |>
    add_xml ~if_not:0. c.latitude (of_float "latitude") |>
    add_xml ~if_not:0. c.altitude (of_float "altitude") |>
    add_xml ~if_not:0. c.heading (of_float "heading") |>
    add_xml ~if_not:0. c.tilt (of_float "tilt") |>
    add_xml ~if_not:0. c.roll (of_float "roll") |>
    add_xml ~if_not:ClampToGround c.altitude_mode of_altitude_mode |>
    of_object "Camera" c.id

  let of_abstract_view = function
    | LookAt l -> of_lookat l
    | Camera c -> of_camera c

  let of_lat_lon_alt_box l =
    let items =
      [ of_float "north" l.north ;
        of_float "south" l.south ;
        of_float "east" l.east ;
        of_float "west" l.west ] |>
      add_xml ~if_not:0. l.min_altitude (of_float "minAltitude") |>
      add_xml ~if_not:0. l.max_altitude (of_float "maxAltitude") |>
      add_xml ~if_not:ClampToGround l.altitude_mode of_altitude_mode in
    Element ("LatLonAltBox", [], items)

  let of_lod l =
    let items =
      add_xml ~if_not:0. l.min_lod_pixels (of_float "minLodPixels") [] |>
      add_xml ~if_not:~-.1. l.max_lod_pixels (of_float "maxLodPixels") |>
      add_xml ~if_not:0. l.min_fade_extent (of_float "minFadeExtent") |>
      add_xml ~if_not:0. l.max_fade_extent (of_float "maxFadeExtent") in
    Element ("Lod", [], items)

  let of_region r =
    [ of_lat_lon_alt_box r.Region.lat_lon_alt_box ] |>
    add_xml_opt r.lod of_lod |>
    of_object "Region" r.id

  let of_color name c =
    of_string name (string_of_color c)

  let of_color_mode mode =
    let s =
      match mode with
      | Normal -> "normal"
      | Random -> "random" in
    of_string "colorMode" s

  let items_of_color_style s =
    add_xml ~if_not:default_bg_color
            s.ColorStyle.color (of_color "bgColor") [] |>
    add_xml ~if_not:Normal s.color_mode of_color_mode

  let of_refresh_mode m =
    let s =
      match m with
      | OnChange -> "onChange"
      | OnInterval -> "onInterval"
      | OnExpire -> "onExpire" in
    of_string "refreshMode" s

  let of_view_refresh_mode m =
    let s =
      match m with
      | Never -> "never"
      | OnStop -> "onStop"
      | OnRequest -> "onRequest"
      | OnRegion -> "onRegion" in
    of_string "viewRefreshMode" s

  let of_icon i =
    add_xml i.Icon.href (of_string "href") [] |>
    add_xml ~if_not:0 i.x (of_int "gx:x") |>
    add_xml ~if_not:0 i.y (of_int "gx:y") |>
    add_xml ~if_not:~-1 i.w (of_int "gx:w") |>
    add_xml ~if_not:~-1 i.h (of_int "gx:h") |>
    add_xml ~if_not:OnChange i.refresh_mode of_refresh_mode |>
    add_xml ~if_not:4. i.refresh_interval (of_float "refreshInterval") |>
    add_xml ~if_not:Never i.view_refresh_mode of_view_refresh_mode |>
    add_xml ~if_not:4. i.view_refresh_time (of_float "viewRefreshTime") |>
    add_xml ~if_not:1. i.view_bound_scale (of_float "viewBoundScale") |>
    add_xml_opt i.view_format (of_string "viewFormat") |>
    add_xml_opt i.http_query (of_string "httpQuery") |>
    of_object "Icon" i.id

  let string_of_units = function
    | Fraction -> "fraction"
    | Pixels -> "pixels"
    | InsetPixels -> "insetPixels"

  let of_xy name xy =
    let attr =
      [ "x", string_of_float xy.x ;
        "y", string_of_float xy.y ;
        "xunits", string_of_units xy.xunits ;
        "yunits", string_of_units xy.yunits ] in
    Element (name, attr, [])

  let of_icon_style (s : IconStyle.t) =
    items_of_color_style s.color_style |>
    add_xml ~if_not:1. s.scale (of_float "scale") |>
    add_xml ~if_not:0. s.heading (of_float "heading") |>
    add_xml_opt s.icon of_icon |>
    add_xml_opt s.hot_spot (of_xy "hotSpot") |>
    of_object "IconStyle" s.color_style.id

  let item_of_color_style s =
    add_xml ~if_not:default_bg_color
            s.ColorStyle.color (of_color "color") [] |>
    add_xml ~if_not:Normal s.color_mode of_color_mode

  let of_label_style s =
    item_of_color_style s.LabelStyle.color_style |>
    add_xml ~if_not:1. s.scale (of_float "scale") |>
    of_object "LabelStyle" s.color_style.id

  let of_line_style s =
    item_of_color_style s.LineStyle.color_style |>
    add_xml ~if_not:1. s.width (of_float "width") |>
    of_object "LineStyle" s.color_style.id

  let of_poly_style s =
    item_of_color_style s.PolyStyle.color_style |>
    add_xml ~if_not:true s.fill (of_bool "fill") |>
    add_xml ~if_not:true s.outline (of_bool "outline") |>
    of_object "PolyStyle" s.color_style.id

  let of_display_mode m =
    let s =
      match m with
      | Default -> "default"
      | Hide -> "hide" in
    of_string "displayMode" s

  let of_balloon_style s =
    add_xml ~if_not:default_bg_color
            s.BalloonStyle.bg_color (of_color "bgColor") [] |>
    add_xml ~if_not:default_text_color s.text_color (of_color "textColor") |>
    add_xml s.text (of_string "text") |>
    add_xml ~if_not:Default s.display_mode of_display_mode |>
    of_object "BalloonStyle" s.id

  let of_item_icon_state s =
    let s =
      match s with
      | ItemIcon.Open -> "open"
      | Closed -> "closed"
      | Error -> "error"
      | Fetching0 -> "fetching0"
      | Fetching1 -> "fetching1"
      | Fetching2 -> "fetching2" in
    of_string "state" s

  let of_item_icon i =
    let items =
      add_xml ~if_not:ItemIcon.Open i.ItemIcon.state of_item_icon_state [] |>
      add_xml i.href (of_string "href") in
    Element ("ItemIcon", [], items)

  let of_list_item_type t =
    let s =
      match t with
      | Check -> "check"
      | CheckOffOnly -> "checkOffOnly"
      | CheckHideChildren -> "checkHideChildren"
      | RadioFolder -> "radioFolder" in
    of_string "listItemType" s

  let of_list_style s =
    let items =
      add_xml ~if_not:Check s.ListStyle.list_item_type of_list_item_type [] |>
      add_xml ~if_not:default_bg_color s.bg_color (of_color "bgColor") in
    List.fold_left (fun items item_icon ->
      of_item_icon item_icon :: items
    ) items s.item_icons |>
    of_object "ListStyle" s.id

  let of_style s =
    add_xml_opt s.icon_style of_icon_style [] |>
    add_xml_opt s.label_style of_label_style |>
    add_xml_opt s.line_style of_line_style |>
    add_xml_opt s.poly_style of_poly_style |>
    add_xml_opt s.balloon_style of_balloon_style |>
    add_xml_opt s.list_style of_list_style |>
    of_object "Style" s.id

  let of_style_map _s = assert false

  let of_style_selector = function
    | Style s -> of_style s
    | StyleMap s -> of_style_map s

  let items_of_feature f =
    let items =
      [ Element ("name", [], [ PCData f.name ]) ] |>
      add_xml ~if_not:true f.visibility (of_bool "visibility") |>
      add_xml ~if_not:false f.open_ (of_bool "open") |>
      add_xml_opt f.address (of_string "address") |>
      add_xml_opt f.phone_number (of_string "phoneNumber") |>
      (* TODO: "maxLines" attribute: *)
      add_xml_opt f.snippet (of_string "Snippet") |>
      add_xml_opt f.description (of_string "description") |>
      add_xml_opt f.abstract_view of_abstract_view |>
      add_xml_opt f.time_primitive of_time_primitive |>
      add_xml_opt f.style_url (of_string "styleUrl") |>
      add_xml_opt f.region of_region in
    List.fold_left (fun items sel ->
      of_style_selector sel :: items
    ) items f.style_selectors

  let of_geometry g = assert false

  let of_placemark p =
    items_of_feature p.Placemark.feature @
    List.map of_geometry p.geometries |>
    of_object "Placemark" p.feature.id

  let of_document _ = assert false
  let of_folder _ = assert false
  let of_network_link _ = assert false
  let of_ground_overlay _ = assert false
  let of_photo_overlay _ = assert false
  let of_screen_overlay _ = assert false

  let of_feature = function
    | Document d -> of_document d
    | Folder f -> of_folder f
    | NetworkLink n -> of_network_link n
    | Placemark p -> of_placemark p
    | GroundOverlay g -> of_ground_overlay g
    | PhotoOverlay p -> of_photo_overlay p
    | ScreenOverlay s -> of_screen_overlay s

  let of_network_link_control _ = assert false

  let of_kml kml =
    let attr = [ "xmlns", xmlns ] in
    let attr =
      match kml.hint with
      | None -> attr
      | Some h -> ("hint", h) :: attr in
    let items =
      match kml.feature with
      | None -> []
      | Some f -> [ of_feature f ] in
    let items =
      match kml.network_link_control with
      | None -> items
      | Some n -> of_network_link_control n :: items in
    Element ("kml", attr, items)
end
