open OkmlType

(*
 * Constructors
 *)

let rec string_of_float f =
  if f = 0. then "0" else  (* take good care of ~-.0. *)
  if f < 0. then "-"^ string_of_float (~-.f) else
  let s = Printf.sprintf "%.5f" f in (* limit number of significant digits to reduce page size *)
  (* chop trailing zeros and trailing dot *)
  let rec chop last l =
    let c = s.[l] in
    if last || l < 1 || c <> '0' && c <> '.' then (
      if l = String.length s - 1 then s else
      String.sub s 0 (l + 1)
    ) else
      chop (c = '.') (l - 1) in
  chop false (String.length s - 1)

let color ?(a=255) ~r ~g ~b () = { a ; r ; g ; b }

let string_of_color c =
  Printf.sprintf "%02x%02x%02x%02x" c.a c.r c.g c.b

let default_bg_color = color ~r:255 ~g:255 ~b:255 ()
let default_text_color = color ~r:0 ~g:0 ~b:0 ()

let coordinates ~lat ~lon ?(alt=0.) () =
  { lat ; lon ; alt }

let balloon_style ?id ?(bg_color=default_bg_color) ?(text_color=default_text_color) ?(display_mode=Default) text =
  BalloonStyle.{ id ; bg_color ; text_color ; text ; display_mode }

let camera ?id ?time_primitive ?(longitude=0.) ?(latitude=0.) ?(altitude=0.) ?(heading=0.) ?(tilt=0.) ?(roll=0.) ?(altitude_mode=ClampToGround) () =
  Camera.{ id ; time_primitive ; longitude ; latitude ; altitude ; heading ;
           tilt ; roll ; altitude_mode }

let feature_params ?id ?name ?(visibility=true) ?(open_=false) ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?(style_selectors=[]) ?region () =
  { id ; name ; visibility ; open_ ; address ; phone_number ; snippet ;
    description ; abstract_view ; time_primitive ; style_url ; style_selectors ;
    region }

let document ?id ?name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region ?(schemas=[]) ?(features=[]) () =
  { feature =
      feature_params ?id ?name ?visibility ?open_ ?address
                     ?phone_number ?snippet ?description ?abstract_view
                     ?time_primitive ?style_url ?style_selectors ?region () ;
    schemas ; features }

let folder ?id ?name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region features =
  { feature =
      feature_params ?id ?name ?visibility ?open_ ?address
                     ?phone_number ?snippet ?description ?abstract_view
                     ?time_primitive ?style_url ?style_selectors ?region () ;
    features }

let overlay_params ?id ?name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region ?(color=color ~r:255 ~g:255 ~b:255 ()) ?(draw_order=0) ~icon =
  { feature =
      feature_params ?id ?name ?visibility ?open_ ?address
                     ?phone_number ?snippet ?description ?abstract_view
                     ?time_primitive ?style_url ?style_selectors ?region () ;
    color ; draw_order ; icon }

let lat_lon_box ?(north=0.) ?(south=0.) ?(east=0.) ?(west=0.) ?(rotation=0.) () =
  { north ; south ; east ; west ; rotation }

let ground_overlay ?id ?name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region ?color ?draw_order ~icon ?(altitude=0.) ?(altitude_mode=ClampToGround) ?lat_lon_box () =
  GroundOverlay.{
    overlay =
      overlay_params ?id ?name ?visibility ?open_ ?address ?phone_number
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

let linear_ring ?id ?(extrude=false) ?(tessellate=false) ?(altitude_mode=ClampToGround) coordinates =
  LinearRing.{ id ; extrude ; tessellate ; altitude_mode ; coordinates }

let line_string ?id ?(extrude=false) ?(tessellate=false) ?(altitude_mode=ClampToGround) ?(draw_order=0) coordinates =
  LineString.{
    id ; extrude ; tessellate ; altitude_mode ; draw_order ; coordinates }

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
  { id ; elements }

let network_link ?id ?name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region ?(refresh_visibility=false) ?(fly_to_view=false) ~link =
  NetworkLink.{
    feature =
      feature_params ?id ?name ?visibility ?open_ ?address
                     ?phone_number ?snippet ?description ?abstract_view
                     ?time_primitive ?style_url ?style_selectors ?region () ;
    refresh_visibility ; fly_to_view ; link }

let network_link_control ?(min_refresh_period=0.) ?(max_session_length= ~-.1.) ?cookie ?message ?link_name ?link_description ?link_snippet ?expires ?(updates=[]) ?abstract_view () =
  NetworkLinkControl.{
    min_refresh_period ; max_session_length ; cookie ; message ; link_name ;
    link_description ; link_snippet ; expires ; updates ; abstract_view }

let view_volume ?(left_fov=0.) ?(right_fov=0.) ?(bottom_fov=0.) ?(top_fov=0.) ?(near=0.) () =
  { left_fov ; right_fov ; bottom_fov ; top_fov ; near }

let photo_overlay ?id ?name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region ?color ?draw_order ~icon ?(rotation=0.) ?(view_volume=view_volume ()) ?image_pyramid ?(shape=Rectangle) ~point =
  PhotoOverlay.{
    overlay =
      overlay_params ?id ?name ?visibility ?open_ ?address ?phone_number
                     ?snippet ?description ?abstract_view ?time_primitive
                     ?style_url ?style_selectors ?region ?color ?draw_order
                     ~icon ;
    rotation ; view_volume ; image_pyramid ; point ; shape }

let placemark ?id ?name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region geometries =
  Placemark.{
    feature =
      feature_params ?id ?name ?visibility ?open_ ?address
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

let screen_overlay ?id ?name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region ?color ?draw_order ~icon ~overlay_xy ~screen_xy ~rotation_xy ?(rotation=0.) ~size =
  ScreenOverlay.{
    overlay =
      overlay_params ?id ?name ?visibility ?open_ ?address ?phone_number
                     ?snippet ?description ?abstract_view ?time_primitive
                     ?style_url ?style_selectors ?region ?color ?draw_order
                     ~icon ;
    overlay_xy ; screen_xy ; rotation_xy ; size ; rotation }

let style ?id ?icon_style ?label_style ?line_style ?poly_style ?balloon_style ?list_style () =
  { id ; icon_style ; label_style ; line_style ; poly_style ; balloon_style ;
    list_style }

let style_map_pair_style ?id style =
  { id ; style }

let style_map ?id ?normal_pair ?highlight_pair () =
  { id ; normal_pair ; highlight_pair }

let time ?(zone=UTC) hour min sec =
  { hour ; min ; sec ; zone }

let date_time ?time year month day =
  { year ; month ; day ; time }

let time_span ?id ?begin_ ?end_ () =
  TimeSpan.{ id ; begin_ ; end_ }

let time_stamp ?id when_ =
  TimeStamp.{ id ; when_ }

let update changes = changes

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
  val to_string : xml -> string
end =
struct
  let xmlns = "http://www.opengis.net/kml/2.2"

  let add_opt v to_xml lst =
    match v with
    | None -> lst
    | Some v -> to_xml v :: lst

  let add ?if_not v to_xml lst =
    match if_not with
    | Some v' when v = v' -> lst
    | _ -> to_xml v :: lst

  let of_object name id_opt ?(attr=[]) items =
    let attr = ("id", id_opt) :: attr in
    let attr =
      List.filter_map (fun (n, v_opt) ->
        match v_opt with
        | None -> None
        | Some v -> Some (n, v)
      ) attr in
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
    add_opt t.TimeSpan.begin_ (of_datetime "begin") [] |>
    add_opt t.end_ (of_datetime "end") |>
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
    add_opt l.LookAt.time_primitive of_time_primitive [] |>
    add ~if_not:0. l.longitude (of_float "longitude") |>
    add ~if_not:0. l.latitude (of_float "latitude") |>
    add ~if_not:0. l.altitude (of_float "altitude") |>
    add ~if_not:0. l.heading (of_float "heading") |>
    add ~if_not:0. l.tilt (of_float "tilt") |>
    add l.range (of_float "range") |>
    add ~if_not:ClampToGround l.altitude_mode of_altitude_mode |>
    of_object "LookAt" l.id

  let of_camera c =
    add_opt c.Camera.time_primitive of_time_primitive [] |>
    add ~if_not:0. c.longitude (of_float "longitude") |>
    add ~if_not:0. c.latitude (of_float "latitude") |>
    add ~if_not:0. c.altitude (of_float "altitude") |>
    add ~if_not:0. c.heading (of_float "heading") |>
    add ~if_not:0. c.tilt (of_float "tilt") |>
    add ~if_not:0. c.roll (of_float "roll") |>
    add ~if_not:ClampToGround c.altitude_mode of_altitude_mode |>
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
      add ~if_not:0. l.min_altitude (of_float "minAltitude") |>
      add ~if_not:0. l.max_altitude (of_float "maxAltitude") |>
      add ~if_not:ClampToGround l.altitude_mode of_altitude_mode in
    Element ("LatLonAltBox", [], items)

  let of_lod l =
    let items =
      add ~if_not:0. l.min_lod_pixels (of_float "minLodPixels") [] |>
      add ~if_not:~-.1. l.max_lod_pixels (of_float "maxLodPixels") |>
      add ~if_not:0. l.min_fade_extent (of_float "minFadeExtent") |>
      add ~if_not:0. l.max_fade_extent (of_float "maxFadeExtent") in
    Element ("Lod", [], items)

  let of_region r =
    [ of_lat_lon_alt_box r.Region.lat_lon_alt_box ] |>
    add_opt r.lod of_lod |>
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
    add ~if_not:default_bg_color
            s.ColorStyle.color (of_color "bgColor") [] |>
    add ~if_not:Normal s.color_mode of_color_mode

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
    add i.Icon.href (of_string "href") [] |>
    add ~if_not:0 i.x (of_int "gx:x") |>
    add ~if_not:0 i.y (of_int "gx:y") |>
    add ~if_not:~-1 i.w (of_int "gx:w") |>
    add ~if_not:~-1 i.h (of_int "gx:h") |>
    add ~if_not:OnChange i.refresh_mode of_refresh_mode |>
    add ~if_not:4. i.refresh_interval (of_float "refreshInterval") |>
    add ~if_not:Never i.view_refresh_mode of_view_refresh_mode |>
    add ~if_not:4. i.view_refresh_time (of_float "viewRefreshTime") |>
    add ~if_not:1. i.view_bound_scale (of_float "viewBoundScale") |>
    add_opt i.view_format (of_string "viewFormat") |>
    add_opt i.http_query (of_string "httpQuery") |>
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
    add ~if_not:1. s.scale (of_float "scale") |>
    add ~if_not:0. s.heading (of_float "heading") |>
    add_opt s.icon of_icon |>
    add_opt s.hot_spot (of_xy "hotSpot") |>
    of_object "IconStyle" s.color_style.id

  let item_of_color_style s =
    add ~if_not:default_bg_color
            s.ColorStyle.color (of_color "color") [] |>
    add ~if_not:Normal s.color_mode of_color_mode

  let of_label_style s =
    item_of_color_style s.LabelStyle.color_style |>
    add ~if_not:1. s.scale (of_float "scale") |>
    of_object "LabelStyle" s.color_style.id

  let of_line_style s =
    item_of_color_style s.LineStyle.color_style |>
    add ~if_not:1. s.width (of_float "width") |>
    of_object "LineStyle" s.color_style.id

  let of_poly_style s =
    item_of_color_style s.PolyStyle.color_style |>
    add ~if_not:true s.fill (of_bool "fill") |>
    add ~if_not:true s.outline (of_bool "outline") |>
    of_object "PolyStyle" s.color_style.id

  let of_display_mode m =
    let s =
      match m with
      | Default -> "default"
      | Hide -> "hide" in
    of_string "displayMode" s

  let of_balloon_style s =
    add ~if_not:default_bg_color
            s.BalloonStyle.bg_color (of_color "bgColor") [] |>
    add ~if_not:default_text_color s.text_color (of_color "textColor") |>
    add s.text (of_string "text") |>
    add ~if_not:Default s.display_mode of_display_mode |>
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
      add ~if_not:ItemIcon.Open i.ItemIcon.state of_item_icon_state [] |>
      add i.href (of_string "href") in
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
      add ~if_not:Check s.ListStyle.list_item_type of_list_item_type [] |>
      add ~if_not:default_bg_color s.bg_color (of_color "bgColor") in
    List.fold_left (fun items item_icon ->
      of_item_icon item_icon :: items
    ) items s.item_icons |>
    of_object "ListStyle" s.id

  let of_style s =
    add_opt s.icon_style of_icon_style [] |>
    add_opt s.label_style of_label_style |>
    add_opt s.line_style of_line_style |>
    add_opt s.poly_style of_poly_style |>
    add_opt s.balloon_style of_balloon_style |>
    add_opt s.list_style of_list_style |>
    of_object "Style" s.id

  let of_pair_style : pair_style -> xml = function
    | Style s -> of_style s
    | StyleUrl url -> of_string "styleUrl" url

  let of_pair key (p : pair) =
    [ of_string "key" key ] |>
    add p.style of_pair_style |>
    of_object "Pair" p.id

  let of_style_map (s : style_map) =
    add_opt s.normal_pair (of_pair "normal") [] |>
    add_opt s.highlight_pair (of_pair "highlight") |>
    of_object "StyleMap" s.id

  let of_style_selector = function
    | Style s -> of_style s
    | StyleMap s -> of_style_map s

  let of_snippet name (s : snippet) =
    let attr =
      match s.max_lines with
      | None -> []
      | Some n -> [ "maxLines", string_of_int n ] in
    of_string ~attr name s.text

  let items_of_feature f =
    let items =
      add_opt f.name (of_string "name") [] |>
      add ~if_not:true f.visibility (of_bool "visibility") |>
      add ~if_not:false f.open_ (of_bool "open") |>
      add_opt f.address (of_string "address") |>
      add_opt f.phone_number (of_string "phoneNumber") |>
      add_opt f.snippet (of_snippet "Snippet") |>
      add_opt f.description (of_string "description") |>
      add_opt f.abstract_view of_abstract_view |>
      add_opt f.time_primitive of_time_primitive |>
      add_opt f.style_url (of_string "styleUrl") |>
      add_opt f.region of_region in
    List.fold_left (fun items sel ->
      of_style_selector sel :: items
    ) items f.style_selectors

  let string_of_coordinates c =
    let s = Printf.sprintf "%g,%g" c.lon c.lat in
    if c.alt <> 0. then s ^ Printf.sprintf ",%g" c.alt
    else s

  let of_coordinates c =
    of_string "coordinates" (string_of_coordinates c)

  let of_point p =
    add ~if_not:false p.Point.extrude (of_bool "extrude") [] |>
    add ~if_not:ClampToGround p.altitude_mode of_altitude_mode |>
    add p.coordinates of_coordinates |>
    of_object "Point" p.id

  let of_line_string s =
    let coords =
      Array.fold_left (fun coords c ->
        coords ^ (if coords <> "" then " " else "") ^ string_of_coordinates c
      ) "" s.LineString.coordinates in
    add ~if_not:false s.extrude (of_bool "extrude") [] |>
    add ~if_not:false s.tessellate (of_bool "tessellate") |>
    add ~if_not:ClampToGround s.altitude_mode of_altitude_mode |>
    add ~if_not:0 s.draw_order (of_int "gx:drawOrder") |>
    add coords (of_string "coordinates") |>
    of_object "LineString" s.id

  let of_linear_ring r =
    let coords =
      Array.fold_left (fun coords c ->
        coords ^ (if coords <> "" then " " else "") ^ string_of_coordinates c
      ) "" r.LinearRing.coordinates in
    add ~if_not:false r.extrude (of_bool "extrude") [] |>
    add ~if_not:false r.tessellate (of_bool "tessellate") |>
    add ~if_not:ClampToGround r.altitude_mode of_altitude_mode |>
    add coords (of_string "coordinates") |>
    of_object "LinearRing" r.id

  let of_polygon p =
    let items =
      add ~if_not:false p.Polygon.extrude (of_bool "extrude") [] |>
      add ~if_not:false p.tessellate (of_bool "tessellate") |>
      add ~if_not:ClampToGround p.altitude_mode of_altitude_mode |>
      List.cons (Element ("outerBoundaryIs", [],
                          [ of_linear_ring p.outer_boundary_is ])) in
    Array.fold_left (fun items ib ->
      Element ("innerBoundaryIs", [], [ of_linear_ring ib ]) :: items
    ) items p.inner_boundary_is |>
    of_object "Polygon" p.id

  let of_link l =
    add_opt l.Link.href (of_string "href") [] |>
    add ~if_not:OnChange l.refresh_mode of_refresh_mode |>
    add ~if_not:4. l.refresh_interval (of_float "refreshInterval") |>
    add ~if_not:Never l.view_refresh_mode of_view_refresh_mode |>
    add ~if_not:4. l.view_refresh_time (of_float "viewRefreshTime") |>
    add ~if_not:1. l.view_bound_scale (of_float "viewBoundScale") |>
    add_opt l.view_format (of_string "viewFormat") |>
    add_opt l.http_query (of_string "httpQuery") |>
    of_object "Link" l.id

  let of_location l =
    let items =
      add l.Location.longitude (of_float "longitude") [] |>
      add l.latitude (of_float "latitude") |>
      add ~if_not:0. l.altitude (of_float "altitude") in
    Element ("Location", [], items)

  let of_orientation o =
    let items =
      add ~if_not:0. o.Orientation.heading (of_float "heading") [] |>
      add ~if_not:0. o.tilt (of_float "tilt") |>
      add ~if_not:0. o.roll (of_float "roll") in
    Element ("Orientation", [], items)

  let of_scale s =
    let items =
      add ~if_not:1. s.Scale.x (of_float "x") [] |>
      add ~if_not:1. s.y (of_float "y") |>
      add ~if_not:1. s.z (of_float "z") in
    Element ("Scale", [], items)

  let of_alias a =
    Element ("Alias", [],
      [ of_string "targetHref" a.target_href ;
        of_string "sourceHref" a.source_href ])

  let of_model m =
    let items =
      add ~if_not:ClampToGround m.Model.altitude_mode of_altitude_mode [] |>
      add m.location of_location |>
      add m.orientation of_orientation |>
      add m.scale of_scale |>
      add m.link of_link in
    List.fold_left (fun items alias ->
      add alias of_alias items
    ) items m.resource_map |>
    of_object "Model" m.id

  let rec of_multi_geometry m =
    List.map of_geometry m.elements |>
    of_object "MultiGeometry" m.id

  and of_geometry = function
    | Point p -> of_point p
    | LineString l -> of_line_string l
    | LinearRing l -> of_linear_ring l
    | Polygon p -> of_polygon p
    | MultiGeometry m -> of_multi_geometry m
    | Model m -> of_model m

  let of_placemark p =
    items_of_feature p.Placemark.feature @
    List.map of_geometry p.geometries |>
    of_object "Placemark" p.feature.id

  let of_network_link l =
    items_of_feature l.NetworkLink.feature |>
    add ~if_not:false l.refresh_visibility (of_bool "refreshVisibility") |>
    add ~if_not:false l.fly_to_view (of_bool "flyToView") |>
    add l.link of_link |>
    of_object "NetworkLink" l.feature.id

  let items_of_overlay (o : overlay_params) =
    items_of_feature o.feature |>
    add ~if_not:default_bg_color o.color (of_color "color") |>
    add ~if_not:0 o.draw_order (of_int "drawOrder") |>
    add o.icon of_icon

  let of_shape s =
    let s =
      match s with
      | Rectangle -> "rectangle"
      | Cylinder -> "cylinder"
      | Sphere -> "sphere" in
    of_string "shape" s

  let of_view_volume (v : view_volume) =
    add ~if_not:0. v.left_fov (of_float "leftFov") [] |>
    add ~if_not:0. v.right_fov (of_float "rightFov") |>
    add ~if_not:0. v.bottom_fov (of_float "bottomFov") |>
    add ~if_not:0. v.top_fov (of_float "topFov") |>
    add ~if_not:0. v.near (of_float "near") |>
    of_object "ViewVolume" None

  let of_grid_origin o =
    let s =
      match o with
      | LowerLeft -> "lowerLeft"
      | UpperLeft -> "upperLeft" in
    of_string "gridOrigin" s

  let of_image_pyramid (p : image_pyramid) =
    add ~if_not:256 p.tile_size (of_int "tileSize") [] |>
    add_opt p.max_width (of_int "maxWidth") |>
    add_opt p.max_height (of_int "maxHeight") |>
    add ~if_not:LowerLeft p.grid_origin of_grid_origin |>
    of_object "ImagePyramid" None

  let of_photo_overlay o =
    items_of_overlay o.PhotoOverlay.overlay |>
    add ~if_not:0. o.rotation (of_float "rotation") |>
    add o.view_volume of_view_volume |>
    add_opt o.image_pyramid of_image_pyramid |>
    add o.point of_point |>
    add ~if_not:Rectangle o.shape of_shape |>
    of_object "photoOverlay" o.overlay.feature.id

  let of_screen_overlay o =
    items_of_overlay o.ScreenOverlay.overlay |>
    add o.overlay_xy (of_xy "overlayXY") |>
    add o.screen_xy (of_xy "screenXY") |>
    add_opt o.rotation_xy (of_xy "rotationXY") |>
    add o.size (of_xy "size") |>
    add ~if_not:0. o.rotation (of_float "rotation") |>
    of_object "ScreenOverlay" o.overlay.feature.id

  let of_lat_lon_box (b : lat_lon_box) =
    add b.north (of_float "north") [] |>
    add b.south (of_float "south") |>
    add b.east (of_float "east") |>
    add b.west (of_float "west") |>
    add ~if_not:0. b.rotation (of_float "rotation") |>
    of_object "LatLonBox" None

  let of_ground_overlay o =
    items_of_overlay o.GroundOverlay.overlay |>
    add ~if_not:0. o.altitude (of_float "altitude") |>
    add ~if_not:ClampToGround o.altitude_mode of_altitude_mode |>
    add_opt o.lat_lon_box of_lat_lon_box |>
    of_object "GroundOverlay" o.overlay.feature.id

  let string_of_simple_field_type = function
    | String -> "string"
    | Int -> "int"
    | Uint -> "uint"
    | Short -> "short"
    | Ushort -> "ushort"
    | Float -> "float"
    | Double -> "double"
    | Bool -> "bool"

  let of_simple_field f =
    let attr =
      [ "type", string_of_simple_field_type f.type_ ;
        "name", f.name ] in
    Element ("SimpleField", attr,
      match f.display_name with
      | None -> []
      | Some n -> [ of_string "displayName" n ])

  let of_schema s =
    List.map of_simple_field s.Schema.simple_fields |>
    of_object "Schema" ~attr:[ "name", s.name ] (Some s.id)

  let rec of_folder (f : folder) =
    items_of_feature f.feature @
    List.map of_feature f.features |>
    of_object "Folder" f.feature.id

  and of_document (d : document) =
    items_of_feature d.feature @
    List.map of_schema d.schemas @
    List.map of_feature d.features |>
    of_object "Document" d.feature.id

  and of_feature = function
    | Document d -> of_document d
    | Folder f -> of_folder f
    | NetworkLink n -> of_network_link n
    | Placemark p -> of_placemark p
    | GroundOverlay g -> of_ground_overlay g
    | PhotoOverlay p -> of_photo_overlay p
    | ScreenOverlay s -> of_screen_overlay s

  let of_update (_op, _data) =
    assert false

  let of_network_link_control c =
    let items =
      add ~if_not:0. c.NetworkLinkControl.min_refresh_period
          (of_float "minRefreshPeriod") [] |>
      add ~if_not:~-.1. c.max_session_length (of_float "maxSessionLength") |>
      add_opt c.cookie (of_string "cookie") |>
      add_opt c.message (of_string "message") |>
      add_opt c.link_name (of_string "linkName") |>
      add_opt c.link_description (of_string "linkDescription") |>
      add_opt c.link_snippet (of_snippet "linkSnippet") |>
      add_opt c.expires (of_datetime "expires") in
    List.fold_left (fun items update ->
      of_update update :: items
    ) items c.updates |>
    add_opt c.abstract_view of_abstract_view |>
    of_object "NetworkLinkControl" None

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

  let to_string xml =
    Xml.to_string_fmt xml
end
