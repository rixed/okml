open OkmlType

let xmlns = "http://www.opengis.net/kml/2.2"

let color ?(a=255) ~r ~g ~b = { a ; r ; g ; b }

let default_bg_color = color ~r:255 ~g:255 ~b:255
let default_text_color = color ~r:0 ~g:0 ~b:0

let balloon_style ?id ?(bg_color=default_bg_color) ?(text_color=default_text_color) ?(display_mode=Default) text =
  { id ; bg_color ; text_color ; text ; display_mode }

let camera ?id ?time_primitive ?(longitude=0.) ?(latitude=0.) ?(altitude=0.) ?(heading=0.) ?(tilt=0.) ?(roll=0.) ?(altitude_mode=ClampToGround) =
  { id ; time_primitive ; longitude ; latitude ; altitude ; heading ; tilt ;
    roll ; altitude_mode }

let feature_params ?id ?name ?(visibility=true) ?(open_=false) ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region () =
  { id ; name ; visibility ; open_ ; address ; phone_number ; snippet ;
    description ; abstract_view ; time_primitive ; style_url ; style_selectors ;
    region }

let document ?id ?name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region schemas features =
  { feature =
      feature_params ?id ?name ?visibility ?open_ ?address
                     ?phone_number ?snippet ?description ?abstract_view
                     ?time_primitive ?style_url ?style_selectors ?region ;
    schemas ; features }

let folder ?id ?name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region features =
  { feature =
      feature_params ?id ?name ?visibility ?open_ ?address
                     ?phone_number ?snippet ?description ?abstract_view
                     ?time_primitive ?style_url ?style_selectors ?region ;
    features }

let overlay_params ?id ?name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region ?(color=color ~r:255 ~g:255 ~b:255) ?(draw_order=0) ?icon =
  { feature =
      feature_params ?id ?name ?visibility ?open_ ?address
                     ?phone_number ?snippet ?description ?abstract_view
                     ?time_primitive ?style_url ?style_selectors ?region ;
    color ; draw_order ; icon }

let lat_lon_box ?north ?south ?east ?west ?rotation () =
  { north ; south ; east ; west ; rotation }

let ground_overlay ?id ?name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region ?color ?draw_order ?icon ?(altiture=0) ?(altitude_mode=ClampToGround) ?lat_lon_box =
  { overlay =
      overlay_params ?id ?name ?visibility ?open_ ?address ?phone_number
                     ?snippet ?description ?abstract_view ?time_primitive
                     ?style_url ?style_selectors ?region ?color ?draw_order
                     ?icon ;
    altitude ; altitude_mode ; lat_lon_box }

let icon ?id ?href ?(x=0.) ?(y=0.) ?(w= ~-.1.) ?(h= ~-.1.) ?(refresh_mode=OnChange) ?(refresh_interval=4.) ?(view_refresh_mode=Never) ?(view_refresh_time=4.) ?(view_bound_scale=1.) ?view_format ?http_query () =
  { id ; href ; x ; y ; w ; h ; refresh_mode ; refresh_interval ;
    view_refresh_mode ; view_refresh_time ; view_bound_scale ; view_format ;
    http_query }

let color_style ?id ?(color=default_bg_color) ?(color_mode=Normal) () =
  { id ; color ; color_mode }

let icon_style ?id ?color ?color_mode ?(scale=1.) ?(heading=0.) ?icon ?hot_spot () =
  { color_style = color_style ?id ?color ?color_mode () ;
    scale ; heading ; icon ; hot_spot }

let kml ?hint ?feature ?network_link_control =
  { hint ; feature ; network_link_control }

let label_style ?id ?color ?color_mode ?(scale=1.) () =
  { color_style = color_style ?id ?color ?color_mode () ;
    scale }

let linear_ring ?id ?(extrude=false) ?(tesselate=false) ?(altitude_mode=ClampToGround) coordinates =
  { id ; extrude ; tesselate ; altitude_mode ; coordinates }

let line_string ?id ?(extrude=false) ?(tesselate=false) ?(altitude_mode=ClampToGround) ?(draw_order=0) coordinates =
  { id ; extrude ; tesselate ; altitude_mode ; coordinates }

let line_style ?id ?color ?color_mode ?(width=1.) () =
  { color_style = color_style ?id ?color ?color_mode () ;
    width }

let link ?id ?href ?(refresh_mode=OnChange) ?(refresh_interval=4.) ?(view_refresh_mode=Never) ?(view_refresh_time=4.) ?(view_bound_scale=1.) ?view_format ?http_query () =
  { id ; href ; refresh_mode ; refresh_interval ; view_refresh_mode ;
    view_refresh_time ; view_bound_scale ; view_format ; http_query }

let list_style ?id ?(list_item_type=Check) ?(bg_color=default_bg_color) item_icons =
  { id ; list_item_type ; bg_color ; item_icons }

let look_at ?id ?time_primitive ?(longitude=0.) ?(latitude=0.) ?(altitude=0.) ?(heading=0.) ?(tilt=0.) ?(altitude_mode=ClampToGround) ~range =
  { id ; time_primitive ; longitude ; latitude ; altitude ; heading ; tilt ;
    range ; altitude_mode }

let orientation ?(heading=0.) ?(tilt=0.) ?(roll=0.) () =
  { heading ; tilt ; roll }

let location ?(altitude=0.) ~longitude ~latitude =
  { longitude ; latitude ; altitude }

let scale ?(x=1.) ?(y=1.) ?(z=1.) () =
  { x ; y ; z }

let model ?id ?(altitude_mode=ClampToGround) ?(location=location ~longitude:0. ~latitude:0.) ?(orientation=orientation ()) ?(scale=scale()) ~link ~resource_map =
  { id ; altitude_mode ; location ; orientation ; scale ; link ;
    resource_map }

let multi_geometry ?id elements =
  { id ; elements }

let network_link ?id ?name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region ?(refresh_visibility=false) ?(fly_to_view=false) ~link =
  { feature =
      feature_params ?id ?name ?visibility ?open_ ?address
                     ?phone_number ?snippet ?description ?abstract_view
                     ?time_primitive ?style_url ?style_selectors ?region ;
    refresh_visibility ; fly_to_view ; link }

let network_link_control ?(min_refresh_period=0.) ?(max_session_length= ~-.1.) ?cookie ?message ?link_name ?link_description ?link_snippet ?expires ?update ?abstract_view () =
  { min_refresh_period ; max_session_length ; cookie ; message ; link_name ;
    link_description ; link_snippet ; expires ; update ; abstract_view }

let view_volume ?(left_fov=0.) ?(right_fov=0.) ?(bottom_fov=0.) ?(top_fov=0.) ?(near=0.) () =
  { left_fov ; right_fov ; bottom_fov ; top_fov ; near }

let photo_overlay ?id ?name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region ?color ?draw_order ?icon ?(rotation=0.) ?(view_volume=view_volume ()) ?image_pyramid ?(shape=Rectangle) ~point =
  { overlay =
      overlay_params ?id ?name ?visibility ?open_ ?address ?phone_number
                     ?snippet ?description ?abstract_view ?time_primitive
                     ?style_url ?style_selectors ?region ?color ?draw_order
                     ?icon ;
    rotation ; view_volume ; image_pyramid ; point ; shape }

let placemark ?id ?name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region geometries =
  { feature =
      feature_params ?id ?name ?visibility ?open_ ?address
                     ?phone_number ?snippet ?description ?abstract_view
                     ?time_primitive ?style_url ?style_selectors ?region ;
    gepometry ; geometries }

let point ?id ?(extrude=false) ?(altitude_mode=ClampToGround) coordinates =
  { id ; extrude ; altitude_mode ; coordinates }

let polygon ?id ?(extrude=false) ?(tessellate=false) ?(altitude_mode=ClampToGround) ~outer_boundary_is ~inner_boundary_is =
  { id ; extrude ; tesselate ; altitude_mode ; outer_boundary_is ; inner_boundary_is }

let poly_style ?id ?color ?color_mode ?(fill=true) ?(outline=true) () =
  { color_style = color_style ?id ?color ?color_mode () ;
    fill ; outline }

let lat_lon_alt_box ~north ~south ~east ~west ?(min_altitude=0.) ?(max_altitude=0.) ?(altitude_mode=ClampToGround) =
  { north ; south ; east ; west ; min_altitude ; max_altitude ; altitude_mode }

let lod ?(min_lod_pixels=0.) ?(max_lod_pixels=1.) ?(min_fade_extent=0.) ?(max_fade_extent=0.) () =
  { min_lod_pixels ; max_lod_pixels ; min_fade_extent ; max_fade_extent }

let region ?id ~lat_lon_alt_box ~lod =
  { id ; lat_lon_alt_box ; lod }

let simple_field ?(display_name) ~type_ ~name =
  { type_ ; name ; display_name }

let schema ~id ?name simple_fields =
  { id ; name ; simple_fields }

let screen_overlay ?id ?name ?visibility ?open_ ?address ?phone_number ?snippet ?description ?abstract_view ?time_primitive ?style_url ?style_selectors ?region ?color ?draw_order ?icon ~overlay_xy ~screen_xy ~rotation_xy ?(rotation=0.) ~size =
  { overlay =
      overlay_params ?id ?name ?visibility ?open_ ?address ?phone_number
                     ?snippet ?description ?abstract_view ?time_primitive
                     ?style_url ?style_selectors ?region ?color ?draw_order
                     ?icon ;
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

let time_span ?id ?begin_ ?end_ =
  { id ; begin_ ; end_ }

let time_stamp ?id when_ =
  { id ; when_ }

let update changes =
  { changes }
