type object_id = string option

type angle_90 = float

type angle_180 = float

type angle_360 = float

type angle_pos_90 = float

type angle_pos_180 = float

type lat_lon_box =
  { (* Specifies the latitude of the north edge of the bounding box, in decimal
       degrees from 0 to ±90. *)
    north : angle_90 ;
    (* Specifies the latitude of the south edge of the bounding box, in decimal
     * degrees from 0 to ±90. *)
    south : angle_90 ;
    (* Specifies the longitude of the east edge of the bounding box, in decimal
     * degrees from 0 to ±180. (For overlays that overlap the meridian of 180°
     * longitude, values can extend beyond that range. *)
    east : angle_180 ;
    (* Specifies the longitude of the west edge of the bounding box, in decimal
     * degrees from 0 to ±180. (For overlays that overlap the meridian of 180°
     * longitude, values can extend beyond that range.) *)
    west : angle_180 ;
    (* Specifies a rotation of the overlay about its center, in degrees. Values
     * can be ±180. The default is 0 (north). Rotations are specified in a
     * counterclockwise direction. *)
    rotation : angle_180 }

type altitude_mode = RelativeToGround | ClampToGround | Absolute

type refresh_mode =
  (* Refresh when the file is loaded and whenever the Link parameters change
   * (the default). *)
  | OnChange
  (* Refresh every n seconds (specified in <refreshInterval>) *)
  | OnInterval
  (* refresh the file when the expiration time is reached. If a fetched file
   * has a NetworkLinkControl, the <expires> time takes precedence over
   * expiration times specified in HTTP headers. If no <expires> time is
   * specified, the HTTP max-age header is used (if present). If max-age is not
   * present, the Expires HTTP header is used (if present). (See Section
   * RFC261b of the Hypertext Transfer Protocol - HTTP 1.1 for details on HTTP
   * header fields.) *)
  | OnExpire

type view_refresh_mode =
  (* Ignore changes in the view. Also ignore <viewFormat> parameters, if any.
   *)
  | Never
  (* Refresh the file n seconds after movement stops, where n is specified in
   * <viewRefreshTime>. *)
  | OnStop
  (* Refresh the file only when the user explicitly requests it. (For example,
   * in Google Earth, the user right-clicks and selects Refresh in the Context
   * menu.) *)
  | OnRequest
  (* Refresh the file when the Region becomes active. *)
  | OnRegion

(* A bounding box that describes an area of interest defined by geographic
 * coordinates and altitudes. *)
type lat_lon_alt_box =
  { (* Specifies the latitude of the north edge of the bounding box, in decimal
       degrees from 0 to ±90. *)
    north : angle_90 ;
    (* Specifies the latitude of the south edge of the bounding box, in decimal
     * degrees from 0 to ±90. *)
    south : angle_90 ;
    (* Specifies the longitude of the east edge of the bounding box, in decimal
     * degrees from 0 to ±180. *)
    east : angle_180 ;
    (* Specifies the longitude of the west edge of the bounding box, in decimal
     * degrees from 0 to ±180. *)
    west : angle_180 ;
    (* Specified in meters (and is affected by the altitude mode specification)
     *)
    min_altitude : float ;
    max_altitude : float ;
    altitude_mode : altitude_mode }

(* Lod is an abbreviation for Level of Detail. <Lod> describes the size of the
 * projected region on the screen that is required in order for the region to
 * be considered "active." Also specifies the size of the pixel ramp used for
 * fading in (from transparent to opaque) and fading out (from opaque to
 * transparent). See diagram below for a visual representation of these
 * parameters. *)
type lod =
  { (* Defines a square in screen space, with sides of the specified value in
       pixels. For example, 128 defines a square of 128 x 128 pixels. The
       region's bounding box must be larger than this square (and smaller than
       the maxLodPixels square) in order for the Region to be active. *)
    min_lod_pixels : float ;
    (* Measurement in screen pixels that represents the maximum limit of the
     * visibility range for a given Region. A value of −1, the default,
     * indicates "active to infinite size." *)
    max_lod_pixels : float ;
    (* Distance over which the geometry fades, from fully opaque to fully
     * transparent. This ramp value, expressed in screen pixels, is applied at
     * the minimum end of the LOD (visibility) limits. *)
    min_fade_extent : float ;
    (* Distance over which the geometry fades, from fully transparent to fully
     * opaque. This ramp value, expressed in screen pixels, is applied at the
     * maximum end of the LOD (visibility) limits. *)
    max_fade_extent : float }

(* A region contains a bounding box (<LatLonAltBox>) that describes an area of
 * interest defined by geographic coordinates and altitudes. In addition, a
 * Region contains an LOD (level of detail) extent (<Lod>) that defines a
 * validity range of the associated Region in terms of projected screen size. A
 * Region is said to be "active" when the bounding box is within the user's
 * view and the LOD requirements are met. Objects associated with a Region are
 * drawn only when the Region is active. When the <viewRefreshMode> is
 * onRegion, the Link or Icon is loaded only when the Region is active. See the
 * "Topics in KML" page on Regions for more details. In a Container or
 * NetworkLink hierarchy, this calculation uses the Region that is the closest
 * ancestor in the hierarchy. *)
module Region =
struct
  type t =
    { id : object_id ;
      lat_lon_alt_box : lat_lon_alt_box ;
      lod : lod option }
end

type simple_field_type =
  String | Int | Uint | Short | Ushort | Float | Double | Bool

type simple_field =
  { type_ : simple_field_type ;
    name : string ;
    display_name : string option }

module Schema =
struct
  (* Specifies a custom KML schema that is used to add custom data to KML
   * Features. The "id" attribute is required and must be unique within the KML
   * file. <Schema> is always a child of <Document>. *)
  type t =
    { id : string ; (* mandatory! *)
      name : string option ;
      (* A Schema element contains one or more SimpleField elements. In the
       * SimpleField, the Schema declares the type and name of the custom field.
       * It optionally specifies a displayName (the user-friendly form, with
       * spaces and proper punctuation used for display in Google Earth) for this
       * custom field. *)
      simple_fields : simple_field list (* At least 1 *)}
end

(* The dateTime is defined according to XML Schema time (see XML Schema Part 2:
 * Datatypes Second Edition). The value can be expressed as
 * yyyy-mm-ddThh:mm:ss.ssszzzzzz, where T is the separator between the date and
 * the time, and the time zone is either Z (for UTC) or zzzzzz, which
 * represents ±hh:mm in relation to UTC. Additionally, the value can be
 * expressed as a date only. *)
type date_time =
  { year : int ;
    month : int ;
    day : int ;
    time : time option }
and time =
  { hour : int ;
    min : int ;
    sec : float ;
    zone : timezone }
and timezone = UTC | Offset of int * int

module TimeSpan =
struct
  (* Represents an extent in time bounded by begin and end dateTimes.
   *
   * If <begin> or <end> is missing, then that end of the period is unbounded. *)
  type t =
    { id : object_id ;
      begin_ : date_time option ;
      end_ : date_time option }
end

module When =
struct
  type t =
    | GYear of int
    | GYearMonth of int * int
    | DateTime of date_time
end

module TimeStamp =
struct
  (* Represents a single moment in time. This is a simple element and contains no
   * children. *)
  type t =
    { id : object_id ;
      when_ : When.t }
end

type time_primitive =
  | TimeSpan of TimeSpan.t
  | TimeStamp of TimeStamp.t

(* Four or more tuples, each consisting of floating point values for longitude,
 * latitude, and altitude. The altitude component is optional. Do not include
 * spaces within a tuple. The last coordinate must be the same as the first
 * coordinate. Coordinates are expressed in decimal degrees only. *)
type coordinate =
  { lat : float ; lon : float ; alt : float option }

module Location =
struct
  (* Latitude and longitude measurements are standard lat-lon projection with
   * WGS84 datum. Altitude is distance above the earth's surface, in meters, and
   * is interpreted according to <altitudeMode>. *)
  type t =
    { longitude : float ;
      latitude : float ;
      altitude : float }
end

module Orientation =
struct
  (* Describes rotation of a 3D model's coordinate system to position the object
   * in Google Earth. Rotations are applied to a Model in the following order:
   * roll, tilt, heading*)
  type t =
    { (* Rotation about the z axis (normal to the Earth's surface). A value of 0
       * (the default) equals North. A positive rotation is clockwise around the z
       * axis and specified in degrees from 0 to 360. *)
      heading : float ;
      (* Rotation about the x axis. A positive rotation is clockwise around the x
       * axis and specified in degrees from 0 to 180. *)
      tilt : float ;
      (* Rotation about the y axis. A positive rotation is clockwise around the y
       * axis and specified in degrees from 0 to 180. *)
      roll : float }
end

module Scale =
struct
  (* Scales a model along the x, y, and z axes in the model's coordinate space. *)
  type t =
    { x : float ;
      y : float ;
      z : float }
end

module LineString =
struct
  (* Defines a connected set of line segments. Use <LineStyle> to specify the
   * color, color mode, and width of the line. When a LineString is extruded,
   * the line is extended to the ground, forming a polygon that looks somewhat
   * like a wall or fence. For extruded LineStrings, the line itself uses the
   * current LineStyle, and the extrusion uses the current PolyStyle. See the
   * KML Tutorial for examples of LineStrings (or paths). *)
  type t =
    { id : object_id ;
      extrude : bool ;
      tesselate : bool ;
      altitude_mode : altitude_mode ;
      (* An integer value that specifies the order for drawing multiple line
       * strings. LineStrings drawn first may be partially or fully obscured by
       * LineStrings with a later draw order. This element may be required in
       * conjunction with the <gx:outerColor> and <gx:outerWidth> elements in
       * <LineStyle> when dual-colored lines cross each other. *)
      draw_order : int ;
      coordinates : coordinate array }
end

module LinearRing =
struct
  (* Defines a closed line string, typically the outer boundary of a Polygon.
   * Optionally, a LinearRing can also be used as the inner boundary of a
   * Polygon to create holes in the Polygon. A Polygon can contain multiple
   * <LinearRing> elements used as inner boundaries. *)
  type t =
    { id : object_id ;
      (* Boolean value. Specifies whether to connect the LinearRing to the
       * ground. To extrude this geometry, the altitude mode must be either
       * relativeToGround, relativeToSeaFloor, or absolute. Only the vertices of
       * the LinearRing are extruded, not the center of the geometry. The
       * vertices are extruded toward the center of the Earth's sphere. *)
      extrude : bool ;
      (* Boolean value. Specifies whether to allow the LinearRing to follow the
       * terrain. To enable tessellation, the value for <altitudeMode> must be
       * clampToGround or clampToSeaFloor. Very large LinearRings should enable
       * tessellation so that they follow the curvature of the earth (otherwise,
       * they may go underground and be hidden). *)
      tesselate : bool ;
      altitude_mode : altitude_mode ;
      coordinates : coordinate array }
end

module Point =
struct
  (* A geographic location defined by longitude, latitude, and (optional)
   * altitude. When a Point is contained by a Placemark, the point itself
   * determines the position of the Placemark's name and icon. When a Point is
   * extruded, it is connected to the ground with a line. This "tether" uses the
   * current LineStyle. *)
  type t =
    { id : object_id ;
      (* Boolean value. Specifies whether to connect the point to the ground with
       * a line. To extrude a Point, the value for <altitudeMode> must be either
       * relativeToGround, relativeToSeaFloor, or absolute. The point is extruded
       * toward the center of the Earth's sphere. *)
      extrude : bool ;
      altitude_mode : altitude_mode ;
      (* A single tuple consisting of floating point values for longitude,
       * latitude, and altitude. *)
      coordinates : coordinate }
end

module Polygon =
struct
  (* A Polygon is defined by an outer boundary and 0 or more inner boundaries.
   * The boundaries, in turn, are defined by LinearRings. When a Polygon is
   * extruded, its boundaries are connected to the ground to form additional
   * polygons, which gives the appearance of a building or a box. Extruded
   * Polygons use <PolyStyle> for their color, color mode, and fill.
   *
   * The <coordinates> for polygons must be specified in counterclockwise order.
   * Polygons follow the "right-hand rule," which states that if you place the
   * fingers of your right hand in the direction in which the coordinates are
   * specified, your thumb points in the general direction of the geometric
   * normal for the polygon. (In 3D graphics, the geometric normal is used for
   * lighting and points away from the front face of the polygon.) Since Google
   * Earth fills only the front face of polygons, you will achieve the desired
   * effect only when the coordinates are specified in the proper order.
   * Otherwise, the polygon will be gray. *)
  type t =
    { id : object_id ;
      (* Boolean value. Specifies whether to connect the Polygon to the ground.
       * To extrude a Polygon, the altitude mode must be either relativeToGround,
       * relativeToSeaFloor, or absolute. Only the vertices are extruded, not the
       * geometry itself (for example, a rectangle turns into a box with five
       * faces. The vertices of the Polygon are extruded toward the center of the
       * Earth's sphere. *)
      extrude : bool ;
      (* This field is not used by Polygon. To allow a Polygon to follow the
       * terrain (that is, to enable tessellation) specify an altitude mode of
       * clampToGround or clampToSeaFloor. *)
      tessellate : bool ;
      altitude_mode : altitude_mode ;
      outer_boundary_is : LinearRing.t ;
      (* A Polygon can contain multiple <innerBoundaryIs> elements, which create
       * multiple cut-outs inside the Polygon. *)
      inner_boundary_is : LinearRing.t array }
end

module Link =
struct
  (* <Link> specifies the location of any of the following:
   *
   * - KML files fetched by network links
   * - Image files used in any Overlay (the <Icon> element specifies the image in
   *   an Overlay; <Icon> has the same fields as <Link>)
   * - Model files used in the <Model> element
   *
   * The file is conditionally loaded and refreshed, depending on the refresh
   * parameters supplied here. Two different sets of refresh parameters can be
   * specified: one set is based on time (<refreshMode> and <refreshInterval>)
   * and one is based on the current "camera" view (<viewRefreshMode> and
   * <viewRefreshTime>). In addition, Link specifies whether to scale the
   * bounding box parameters that are sent to the server (<viewBoundScale> and
   * provides a set of optional viewing parameters that can be sent to the
   * server (<viewFormat>) as well as a set of optional parameters containing
   * version and language information.
   *
   * When a file is fetched, the URL that is sent to the server is composed of
   * three pieces of information:
   *
   * - the href (Hypertext Reference) that specifies the file to load.
   * - an arbitrary format string that is created from (a) parameters that you
   *   specify in the <viewFormat> element or (b) bounding box parameters (this
   *   is the default and is used if no <viewFormat> element is included in the
   *   file).
   * - a second format string that is specified in the <httpQuery> element.
   * If the file specified in <href> is a local file, the <viewFormat> and
   * <httpQuery> elements are not used.
   *
   * The <Link> element replaces the <Url> element of <NetworkLink> contained
   * in earlier KML releases and adds functionality for the <Region> element
   * (introduced in KML 2.1). In Google Earth releases 3.0 and earlier, the
   * <Link> element is ignored. *)
  type t =
    { id : object_id ;
      (* A URL (either an HTTP address or a local file specification). When the
       * parent of <Link> is a NetworkLink, <href> is a KML file. When the parent
       * of <Link> is a Model, <href> is a COLLADA file. When the parent of
       * <Icon> (same fields as <Link>) is an Overlay, <href> is an image.
       * Relative URLs can be used in this tag and are evaluated relative to the
       * enclosing KML file. See KMZ Files for details on constructing relative
       * references in KML and KMZ files. *)
      href : string option ;
      refresh_mode : refresh_mode ;
      (* Indicates to refresh the file every n seconds. *)
      refresh_interval : float ;
      view_refresh_mode : view_refresh_mode ;
      (* After camera movement stops, specifies the number of seconds to wait
       * before refreshing the view. (See <viewRefreshMode> and onStop above.) *)
      view_refresh_time : float ;
      (* Scales the BBOX parameters before sending them to the server. A value
       * less than 1 specifies to use less than the full view (screen). A value
       * greater than 1 specifies to fetch an area that extends beyond the edges
       * of the current view. *)
      view_bound_scale : float ;
      (* Specifies the format of the query string that is appended to the Link's
       * <href> before the file is fetched.(If the <href> specifies a local file,
       * this element is ignored.)
       * If you specify a <viewRefreshMode> of onStop and do not include the
       * <viewFormat> tag in the file, the following information is automatically
       * appended to the query string:
       * BBOX=[bboxWest],[bboxSouth],[bboxEast],[bboxNorth]
       * This information matches the Web Map Service (WMS) bounding box
       * specification.
       * If you specify an empty <viewFormat> tag, no information is appended to
       * the query string.
       * You can also specify a custom set of viewing parameters to add to the
       * query string. If you supply a format string, it is used instead of the
       * BBOX information. If you also want the BBOX information, you need to add
       * those parameters along with the custom parameters.
       * You can use any of the following parameters in your format string (and
       * Google Earth will substitute the appropriate current value at the time
       * it creates the query string):
       * - [lookatLon], [lookatLat] - longitude and latitude of the point that
       * <LookAt> is viewing
       * - [lookatRange], [lookatTilt], [lookatHeading] - values used by the
       * <LookAt> element (see descriptions of <range>, <tilt>, and <heading> in
       * <LookAt>)
       * - [lookatTerrainLon], [lookatTerrainLat], [lookatTerrainAlt] - point on
       * the terrain in degrees/meters that <LookAt> is viewing
       * - [cameraLon], [cameraLat], [cameraAlt] - degrees/meters of the eyepoint
       * for the camera
       * - [horizFov], [vertFov] - horizontal, vertical field of view for the
       * camera
       * - [horizPixels], [vertPixels] - size in pixels of the 3D viewer
       * - [terrainEnabled] - indicates whether the 3D viewer is showing terrain.
       *)
      view_format : string option ;
      (* Appends information to the query string, based on the parameters
       * specified. (Google Earth substitutes the appropriate current value at
       * the time it creates the query string.) The following parameters are
       * supported:
       * - [clientVersion]
       * - [kmlVersion]
       * - [clientName]
       * - [language] *)
      http_query : string option }
end

(* <Alias> contains a mapping from a <sourceHref> to a <targetHref> *)
type alias =
  { target_href : string ;
    source_href : string }

type geometry =
  | Point of Point.t
  | LineString of LineString.t
  | LinearRing of LinearRing.t
  | Polygon of Polygon.t
  | MultiGeometry of multi_geometry
  | Model of model

(* A container for zero or more geometry primitives associated with the same
 * feature. *)
and multi_geometry =
  { id : object_id ;
    elements : geometry list }

(* A 3D object described in a COLLADA file (referenced in the <Link> tag).
 * COLLADA files have a .dae file extension. Models are created in their own
 * coordinate space and then located, positioned, and scaled in Google Earth.
 * See the "Topics in KML" page on Models for more detail. *)
and model =
  { id : object_id ;
    altitude_mode : altitude_mode ;
    location : Location.t ;
    (* Describes rotation of a 3D model's coordinate system to position the
     * object in Google Earth. *)
    orientation : Orientation.t ;
    (* Scales a model along the x, y, and z axes in the model's coordinate
     * space. *)
    scale : Scale.t ;
    (* Specifies the file to load and optional refresh parameters. *)
    link : Link.t ;
    (* Specifies 0 or more <Alias> elements, each of which is a mapping for the
     * texture file path from the original Collada file to the KML or KMZ file
     * that contains the Model. This element allows you to move and rename
     * texture files without having to update the original Collada file that
     * references those textures. One <ResourceMap> element can contain
     * multiple mappings from different (source) Collada files into the same
     * (target) KMZ file. *)
    resource_map : alias list }

module MultiGeometry =
struct
  type t = multi_geometry
end

module Model =
struct
  type t = model
end

module Camera =
struct
  (* Defines the virtual camera that views the scene. This element defines the
   * position of the camera relative to the Earth's surface as well as the
   * viewing direction of the camera. The camera position is defined by
   * <longitude>, <latitude>, <altitude>, and either <altitudeMode> or
   * <gx:altitudeMode>. The viewing direction of the camera is defined by
   * <heading>, <tilt>, and <roll>. <Camera> can be a child element of any
   * Feature or of <NetworkLinkControl>. A parent element cannot contain both a
   * <Camera> and a <LookAt> at the same time.
   *
   * <Camera> provides full six-degrees-of-freedom control over the view, so
   * you can position the Camera in space and then rotate it around the X, Y,
   * and Z axes. Most importantly, you can tilt the camera view so that you're
   * looking above the horizon into the sky.
   *
   * <Camera> can also contain a TimePrimitive (<gx:TimeSpan> or
   * <gx:TimeStamp>). Time values in Camera affect historical imagery,
   * sunlight, and the display of time-stamped features. For more information,
   * read Time with AbstractViews in the Time and Animation chapter of the
   * Developer's Guide. *)
  type t =
    { id : object_id ;
      time_primitive : time_primitive option ;
      longitude : angle_180 ;
      latitude : angle_90 ;
      altitude : float ;
      (* rotate around the Z axis. *)
      heading : angle_360 ;
      (* rotate around the X axis. *)
      tilt : angle_pos_180 ;
      (* rotate around the Z axis (again). *)
      roll : angle_180 ;
      altitude_mode : altitude_mode }
end

module LookAt =
struct
  (* Defines a virtual camera that is associated with any element derived from
   * Feature. The LookAt element positions the "camera" in relation to the
   * object that is being viewed. In Google Earth, the view "flies to" this
   * LookAt viewpoint when the user double-clicks an item in the Places panel
   * or double-clicks an icon in the 3D viewer. *)
  type t =
    { id : object_id ;
      time_primitive : time_primitive option ;
      longitude : angle_180 ;
      latitude : angle_90 ;
      altitude : float ;
      heading : angle_360 ;
      tilt : angle_pos_90 ;
      (* Distance in meters from the point specified by <longitude>, <latitude>,
       * and <altitude> to the LookAt position. (See diagram below.) *)
      range : float ;
      altitude_mode : altitude_mode }
end

type abstract_view =
  | LookAt of LookAt.t
  | Camera of Camera.t

type color = { a : int ; r : int ; g : int ; b : int }

type color_mode = Normal | Random

type list_item_type =
  Check | CheckOffOnly | CheckHideChildren | RadioFolder

module ItemIcon =
struct
  type state =
    Open | Closed | Error | Fetching0 | Fetching1 | Fetching2

  type t =
    { state : state ;
      href : string }
end

module ColorStyle =
struct
  type t =
    { id : object_id ;
      color : color ;
      color_mode : color_mode }
end

(* A value of "fraction" indicates the x value is a fraction of the screen. A
 * value of "pixels" indicates the x value in pixels. A value of "insetPixels"
 * indicates the indent from the right edge of the screen. *)
type units = Fraction | Pixels | InsetPixels

(* Specifies the position within the Icon that is "anchored" to the <Point>
 * specified in the Placemark. The x and y values can be specified in three
 * different ways: as pixels ("pixels"), as fractions of the icon ("fraction"),
 * or as inset pixels ("insetPixels"), which is an offset in pixels from the
 * upper right corner of the icon. The x and y positions can be specified in
 * different ways—for example, x can be in pixels and y can be a fraction. The
 * origin of the coordinate system is in the lower left corner of the icon. *)
type x_y =
  { (* Either the number of pixels, a fractional component of the icon, or a
       pixel inset indicating the x component of a point on the icon. *)
    x : float ;
    (* Either the number of pixels, a fractional component of the icon, or a
     * pixel inset indicating the y component of a point on the icon. *)
    y : float ;
    (* Units in which the x value is specified. A value of fraction indicates
     * the x value is a fraction of the icon. A value of pixels indicates the x
     * value in pixels. A value of insetPixels indicates the indent from the
     * right edge of the icon. *)
    xunits : units ;
    (* Units in which the y value is specified. A value of fraction indicates
     * the y value is a fraction of the icon. A value of pixels indicates the y
     * value in pixels. A value of insetPixels indicates the indent from the
     * top edge of the icon. *)
    yunits : units }

type display_mode = Default | Hide

module Icon =
struct
  (* Defines an image associated with an Icon style or overlay. The required
   * <href> child element defines the location of the image to be used as the
   * overlay or as the icon for the placemark. This location can either be on a
   * local file system or a remote web server. The <gx:x>, <gx:y>, <gx:w>, and
   * <gx:h> elements are used to select one icon from an image that contains
   * multiple icons (often referred to as an icon palette. *)
  type t =
    { id : object_id ;
      (* An HTTP address or a local file specification used to load an icon. *)
      href : string ;
      (* If the <href> specifies an icon palette, these elements identify the
       * offsets, in pixels, from the lower-left corner of the icon palette.If no
       * values are specified for x and y, the lower left corner of the icon
       * palette is assumed to be the lower-left corner of the icon to use. *)
      x : int ;
      y : int ;
      (* If the <href> specifies an icon palette, these elements specify the
       * width (<gx:w>) and height (<gx:h>), in pixels, of the icon to use. *)
      w : int ;
      h : int ;
      refresh_mode : refresh_mode ;
      refresh_interval : float ;
      view_refresh_mode : view_refresh_mode ;
      view_refresh_time : float ;
      view_bound_scale : float ;
      view_format : string option ;
      http_query : string option }
end

module IconStyle =
struct
  (* Specifies how icons for point Placemarks are drawn, both in the Places
   * panel and in the 3D viewer of Google Earth. The <Icon> element specifies
   * the icon image. The <scale> element specifies the x, y scaling of the
   * icon. The color specified in the <color> element of <IconStyle> is blended
   * with the color of the <Icon>. *)
  type t =
    { color_style : ColorStyle.t ;
      (* Resizes the icon.  *  *)
      scale : float ;
      (* Direction (that is, North, South, East, West), in degrees. Default=0
       * (North). (See diagram.) Values range from 0 to 360 degrees. *)
      heading : float ;
      (* A custom Icon. In <IconStyle>, the only child element of <Icon> is
       * <href> *)
      icon : Icon.t option ;
      (* Specifies the position within the Icon that is "anchored" to the <Point>
       * specified in the Placemark. The x and y values can be specified in three
       * different ways: as pixels ("pixels"), as fractions of the icon
       * ("fraction"), or as inset pixels ("insetPixels"), which is an offset in
       * pixels from the upper right corner of the icon. The x and y positions
       * can be specified in different ways—for example, x can be in pixels and y
       * can be a fraction. The origin of the coordinate system is in the lower
       * left corner of the icon. *)
      hot_spot : x_y option }
end

module LabelStyle =
struct
  (* Specifies how the <name> of a Feature is drawn in the 3D viewer. A custom
   * color, color mode, and scale for the label (name) can be specified. *)
  type t =
    { color_style : ColorStyle.t ;
      scale: float }
end

module LineStyle =
struct
  (* Specifies the drawing style (color, color mode, and line width) for all
   * line geometry. Line geometry includes the outlines of outlined polygons
   * and the extruded "tether" of Placemark icons (if extrusion is enabled). *)
  type t =
    { color_style : ColorStyle.t ;
      (* Width of the line, in pixels. *)
      width : float }
end

module PolyStyle =
struct
  (* Specifies the drawing style for all polygons, including polygon extrusions
   * (which look like the walls of buildings) and line extrusions (which look
   * like solid fences). *)
  type t =
    { color_style : ColorStyle.t ;
      (* Specifies whether to fill the polygon. *)
      fill : bool ;
      (* Specifies whether to outline the polygon. Polygon outlines use the
       * current LineStyle. *)
      outline : bool }
end

module BalloonStyle =
struct
  (* Specifies how the description balloon for placemarks is drawn. The
   * <bgColor>, if specified, is used as the background color of the balloon.
   * See <Feature> for a diagram illustrating how the default description
   * balloon appears in Google Earth. *)
  type t =
    { id : object_id ;
      (* Background color of the balloon (optional). Color and opacity (alpha)
       * values are expressed in hexadecimal notation. The range of values for
       * any one color is 0 to 255 (00 to ff). The order of expression is
       * aabbggrr, where aa=alpha (00 to ff); bb=blue (00 to ff); gg=green (00 to
       * ff); rr=red (00 to ff). For alpha, 00 is fully transparent and ff is
       * fully opaque. For example, if you want to apply a blue color with 50
       * percent opacity to an overlay, you would specify the following:
       * <bgColor>7fff0000</bgColor>, where alpha=0x7f, blue=0xff, green=0x00,
       * and red=0x00. The default is opaque white (ffffffff). *)
      bg_color : color ;
      (* Foreground color for text. The default is black (ff000000). *)
      text_color : color ;
      (* Text displayed in the balloon. If no text is specified, Google Earth
       * draws the default balloon (with the Feature <name> in boldface, the
       * Feature <description>, links for driving directions, a white background,
       * and a tail that is attached to the point coordinates of the Feature, if
       * specified).
       *
       * You can add entities to the <text> tag using the following format to
       * refer to a child element of Feature: $[name], $[description],
       * $[address], $[id], $[Snippet]. Google Earth looks in the current Feature
       * for the corresponding string entity and substitutes that information in
       * the balloon. To include To here - From here driving directions in the
       * balloon, use the $[geDirections] tag. To prevent the driving directions
       * links from appearing in a balloon, include the <text> element with some
       * content, or with $[description] to substitute the basic Feature
       * <description>.
       *
       * For example, in the following KML excerpt, $[name] and $[description]
       * fields will be replaced by the <name> and <description> fields found in
       * the Feature elements that use this BalloonStyle:
       *
       * <text>This is $[name], whose description is:<br/>$[description]</text>
       *)
      text : string ;
      display_mode : display_mode }
end

module ListStyle =
struct
  (* Specifies how a Feature is displayed in the list view. The list view is a
   * hierarchy of containers and children; in Google Earth, this is the Places
   * panel. *)
  type t =
    { id : object_id ;
      list_item_type : list_item_type ;
      bg_color : color ;
      item_icons : ItemIcon.t list }
end

type pair_style = Style of style | StyleUrl of string

and pair =
  { id : object_id ;
    style : pair_style }

(* A <StyleMap> maps between two different Styles. Typically a <StyleMap>
 * element is used to provide separate normal and highlighted styles for a
 * placemark, so that the highlighted version appears when the user mouses over
 * the icon in Google Earth. *)
and style_map =
  { id : object_id ;
    (* At least one must be defined: *)
    normal_pair : pair option ;
    highlighted_pair : pair option }

(* A Style defines an addressable style group that can be referenced by
 * StyleMaps and Features. Styles affect how Geometry is presented in the 3D
 * viewer and how Features appear in the Places panel of the List view. Shared
 * styles are collected in a <Document> and must have an id defined for them so
 * that they can be referenced by the individual Features that use them.
 *
 * Use an id to refer to the style from a <styleUrl>. *)
and style =
  { id : object_id ;
    icon_style : IconStyle.t option ;
    label_style : LabelStyle.t option ;
    line_style : LineStyle.t option ;
    poly_style : PolyStyle.t option ;
    balloon_style : BalloonStyle.t option ;
    list_style : ListStyle.t option }

type style_selector = Style of style | StyleMap of style_map

(* This is an abstract element and cannot be used directly in a KML file. The
 * following diagram shows how some of a Feature's elements appear in Google
 * Earth. *)
and feature_params =
  { id : object_id ;
    (* User-defined text displayed in the 3D viewer as the label for the object
     * (for example, for a Placemark, Folder, or NetworkLink). *)
    name : string ;
    (* Boolean value. Specifies whether the feature is drawn in the 3D viewer
     * when it is initially loaded. In order for a feature to be visible, the
     * <visibility> tag of all its ancestors must also be set to 1. In the
     * Google Earth List View, each Feature has a checkbox that allows the user
     * to control visibility of the Feature. *)
    visibility : bool ;
    (* Boolean value. Specifies whether a Document or Folder appears closed or
     * open when first loaded into the Places panel. 0=collapsed (the default),
     * 1=expanded. See also <ListStyle>. This element applies only to Document,
     * Folder, and NetworkLink. *)
    open_ : bool ;
    (* A string value representing an unstructured address written as a
     * standard street, city, state address, and/or as a postal code. You can
     * use the <address> tag to specify the location of a point instead of
     * using latitude and longitude coordinates. (However, if a <Point> is
     * provided, it takes precedence over the <address>.) To find out which
     * locales are supported for this tag in Google Earth, go to the Google
     * Maps Help. *)
    address : string option ;
    (* A string value representing a telephone number. This element is used by
     * Google Maps Mobile only. The industry standard for Java-enabled cellular
     * phones is RFC2806. *)
    phone_number : string option ;
    (* A short description of the feature. In Google Earth, this description is
     * displayed in the Places panel under the name of the feature. If a
     * Snippet is not supplied, the first two lines of the <description> are
     * used. In Google Earth, if a Placemark contains both a description and a
     * Snippet, the <Snippet> appears beneath the Placemark in the Places
     * panel, and the <description> appears in the Placemark's description
     * balloon. This tag does not support HTML markup. <Snippet> has a maxLines
     * attribute, an integer that specifies the maximum number of lines to
     * display. *)
    snippet : string option ;
    (* User-supplied content that appears in the description balloon. *)
    description : string option ;
    (* Defines a viewpoint associated with any element derived from Feature.
     * See <Camera> and <LookAt>. *)
    abstract_view : abstract_view option ;
    (* Associates this Feature with a period of time (<TimeSpan>) or a point in
     * time (<TimeStamp>). *)
    time_primitive : time_primitive option ;
    (* URL of a <Style> or <StyleMap> defined in a Document. If the style is in
     * the same file, use a # reference. If the style is defined in an external
     * file, use a full URL along with # referencing. *)
    style_url : string option ;
    (* One or more Styles and StyleMaps can be defined to customize the
     * appearance of any element derived from Feature or of the Geometry in a
     * Placemark. (See <BalloonStyle>, <ListStyle>, <StyleSelector>, and the
     * styles derived from <ColorStyle>.) A style defined within a Feature is
     * called an "inline style" and applies only to the Feature that contains
     * it. A style defined as the child of a <Document> is called a "shared
     * style." A shared style must have an id defined for it. This id is
     * referenced by one or more Features within the <Document>. In cases where
     * a style element is defined both in a shared style and in an inline style
     * for a Feature—that is, a Folder, GroundOverlay, NetworkLink, Placemark,
     * or ScreenOverlay—the value for the Feature's inline style takes
     * precedence over the value for the shared style. *)
    style_selectors : style_selector list ;
    (* Features and geometry associated with a Region are drawn only when the
     * Region is active. See <Region>. *)
    region : Region.t option }

type overlay_params =
  { feature : feature_params ;
    color : color ;
    draw_order : int ;
    icon : Icon.t }

(* Defines how much of the current scene is visible. Specifying the field of
 * view is analogous to specifying the lens opening in a physical camera. A
 * small field of view, like a telephoto lens, focuses on a small part of the
 * scene. A large field of view, like a wide-angle lens, focuses on a large
 * part of the scene. *)
type view_volume =
  { (* Angle, in degrees, between the camera's viewing direction and the left
       side of the view volume. *)
    left_fov : angle_180 ;
    (* Angle, in degrees, between the camera's viewing direction and the right
     * side of the view volume. *)
    right_fov : angle_180 ;
    (* Angle, in degrees, between the camera's viewing direction and the bottom
     * side of the view volume. *)
    bottom_fov : angle_90 ;
    (* Angle, in degrees, between the camera's viewing direction and the top
     * side of the view volume. *)
    top_fov : angle_90 ;
    (* Measurement in meters along the viewing direction from the camera
     * viewpoint to the PhotoOverlay shape. *)
    near : float }

type grid_origin = LowerLeft | UpperLeft

(* For very large images, you'll need to construct an image pyramid, which is a
 * hierarchical set of images, each of which is an increasingly lower
 * resolution version of the original image. Each image in the pyramid is
 * subdivided into tiles, so that only the portions in view need to be loaded.
 * Google Earth calculates the current viewpoint and loads the tiles that are
 * appropriate to the user's distance from the image. As the viewpoint moves
 * closer to the PhotoOverlay, Google Earth loads higher resolution tiles.
 * Since all the pixels in the original image can't be viewed on the screen at
 * once, this preprocessing allows Google Earth to achieve maximum performance
 * because it loads only the portions of the image that are in view, and only
 * the pixel details that can be discerned by the user at the current
 * viewpoint.
 *
 * When you specify an image pyramid, you also modify the <href> in the <Icon>
 * element to include specifications for which tiles to load.
 *)
type image_pyramid =
  { (* Size of the tiles, in pixels. Tiles must be square, and <tileSize> must
       be a power of 2. A tile size of 256 (the default) or 512 is recommended.
       The original image is divided into tiles of this size, at varying
       resolutions. *)
    tile_size : int option ;
    (* Width in pixels of the original image. *)
    max_width : int option ;
    (* Height in pixels of the original image. *)
    max_height : int option ;
    (* Specifies where to begin numbering the tiles in each layer of the
     * pyramid. A value of lowerLeft specifies that row 1, column 1 of each
     * layer is in the bottom left corner of the grid. *)
    grid_origin : grid_origin }

type shape = Rectangle | Cylinder | Sphere

module PhotoOverlay =
struct
  (* The <PhotoOverlay> element allows you to geographically locate a photograph
   * on the Earth and to specify viewing parameters for this PhotoOverlay. The
   * PhotoOverlay can be a simple 2D rectangle, a partial or full cylinder, or a
   * sphere (for spherical panoramas). The overlay is placed at the specified
   * location and oriented toward the viewpoint.
   *
   * Because <PhotoOverlay> is derived from <Feature>, it can contain one of the
   * two elements derived from <AbstractView>—either <Camera> or <LookAt>. The
   * Camera (or LookAt) specifies a viewpoint and a viewing direction (also
   * referred to as a view vector). The PhotoOverlay is positioned in relation to
   * the viewpoint. Specifically, the plane of a 2D rectangular image is
   * orthogonal (at right angles to) the view vector. The normal of this
   * plane—that is, its front, which is the part with the photo—is oriented
   * toward the viewpoint.
   *
   * The URL for the PhotoOverlay image is specified in the <Icon> tag, which is
   * inherited from <Overlay>. The <Icon> tag must contain an <href> element that
   * specifies the image file to use for the PhotoOverlay. In the case of a very
   * large image, the <href> is a special URL that indexes into a pyramid of
   * images of varying resolutions (see ImagePyramid).
   *
   * For more information, see the "Topics in KML" page on PhotoOverlay. *)
  type t =
    { overlay : overlay_params ;
      (* Adjusts how the photo is placed inside the field of view. This element
       * is useful if your photo has been rotated and deviates slightly from a
       * desired horizontal view. *)
      rotation : angle_180 ;
      view_volume : view_volume ;
      image_pyramid : image_pyramid option ;
      (* The <Point> element acts as a <Point> inside a <Placemark> element. It
       * draws an icon to mark the position of the PhotoOverlay. The icon drawn
       * is specified by the <styleUrl> and <StyleSelector> fields, just as it is
       * for <Placemark>. *)
      point : coordinate ;
      (* The PhotoOverlay is projected onto the <shape>. *)
      shape : shape }
end

module ScreenOverlay =
struct
  (* This element draws an image overlay fixed to the screen. Sample uses for
   * ScreenOverlays are compasses, logos, and heads-up displays. ScreenOverlay
   * sizing is determined by the <size> element. Positioning of the overlay is
   * handled by mapping a point in the image specified by <overlayXY> to a point
   * on the screen specified by <screenXY>. Then the image is rotated by
   * <rotation> degrees about a point relative to the screen specified by
   * <rotationXY>.
   *
   * The <href> child of <Icon> specifies the image to be used as the overlay.
   * This file can be either on a local file system or on a web server. If this
   * element is omitted or contains no <href>, a rectangle is drawn using the
   * color and size defined by the screen overlay. *)
  type t =
    { overlay : overlay_params ;
      (* Specifies a point on (or outside of) the overlay image that is mapped to
       * the screen coordinate (<screenXY>). It requires x and y values, and the
       * units for those values. *)
      overlay_xy : x_y ;
      (* Specifies a point relative to the screen origin that the overlay image
       * is mapped to. The x and y values can be specified in three different
       * ways: as pixels ("pixels"), as fractions of the screen ("fraction"), or
       * as inset pixels ("insetPixels"), which is an offset in pixels from the
       * upper right corner of the screen. The x and y positions can be specified
       * in different ways — for example, x can be in pixels and y can be a
       * fraction. The origin of the coordinate system is in the lower left
       * corner of the screen.*)
      screen_xy : x_y ;
      (* Point relative to the screen about which the screen overlay is rotated. *)
      rotation_xy : x_y option ;
      (* Specifies the size of the image for the screen overlay, as follows:
       * - A value of −1 indicates to use the native dimension
       * - A value of 0 indicates to maintain the aspect ratio
       * - A value of n sets the value of the dimension *)
      size : x_y ;
      (* Indicates the angle of rotation of the parent object. A value of 0 means
       * no rotation. The value is an angle in degrees counterclockwise starting
       * from north. Use ±180 to indicate the rotation of the parent object from
       * 0. The center of the <rotation>, if not (.5,.5), is specified in
       * <rotationXY>. *)
      rotation : float }
end

module GroundOverlay =
struct
  (* This element draws an image overlay draped onto the terrain. The <href>
   * child of <Icon> specifies the image to be used as the overlay. This file
   * can be either on a local file system or on a web server. If this element
   * is omitted or contains no <href>, a rectangle is drawn using the color and
   * LatLonBox bounds defined by the ground overlay. *)
  type t =
    { overlay : overlay_params ;
      (* Specifies the distance above the earth's surface, in meters, and is
       * interpreted according to the altitude mode. *)
      altitude : float ;
      altitude_mode : altitude_mode ;
      (* Specifies where the top, bottom, right, and left sides of a bounding box
       * for the ground overlay are aligned.  *)
      lat_lon_box : lat_lon_box option }
end

module Placemark =
struct
  (* A Placemark is a Feature with associated Geometry. In Google Earth, a
   * Placemark appears as a list item in the Places panel. A Placemark with a
   * Point has an icon associated with it that marks a point on the Earth in the
   * 3D viewer. (In the Google Earth 3D viewer, a Point Placemark is the only
   * object you can click or roll over. Other Geometry objects do not have an
   * icon in the 3D viewer. To give the user something to click in the 3D viewer,
   * you would need to create a MultiGeometry object that contains both a Point
   * and the other Geometry object.) *)
  type t =
    { feature : feature_params ;
      geometries : geometry list }
end

module NetworkLink =
struct
  (* References a KML file or KMZ archive on a local or remote network. Use the
   * <Link> element to specify the location of the KML file. Within that element,
   * you can define the refresh options for updating the file, based on time and
   * camera change. NetworkLinks can be used in combination with Regions to
   * handle very large datasets efficiently. *)
  type t =
    { feature : feature_params ;
      (* Boolean value. A value of 0 leaves the visibility of features within the
       * control of the Google Earth user. Set the value to 1 to reset the
       * visibility of features each time the NetworkLink is refreshed. For
       * example, suppose a Placemark within the linked KML file has <visibility>
       * set to 1 and the NetworkLink has <refreshVisibility> set to 1. When the
       * file is first loaded into Google Earth, the user can clear the check box
       * next to the item to turn off display in the 3D viewer. However, when the
       * NetworkLink is refreshed, the Placemark will be made visible again,
       * since its original visibility state was TRUE. *)
      refresh_visibility : bool ;
      (* Boolean value. A value of 1 causes Google Earth to fly to the view of
       * the LookAt or Camera in the NetworkLinkControl (if it exists). If the
       * NetworkLinkControl does not contain an AbstractView element, Google
       * Earth flies to the LookAt or Camera element in the Feature child within
       * the <kml> element in the refreshed file. If the <kml> element does not
       * have a LookAt or Camera specified, the view is unchanged. For example,
       * Google Earth would fly to the <LookAt> view of the parent Document, not
       * the <LookAt> of the Placemarks contained within the Document. *)
      fly_to_view : bool ;
      link : Link.t }
end

(* A Folder is used to arrange other Features hierarchically (Folders,
 * Placemarks, NetworkLinks, or Overlays). A Feature is visible only if it and
 * all its ancestors are visible. *)
type folder =
  { feature : feature_params ;
    features : feature list }

(* A Document is a container for features and styles. This element is
 * required if your KML file uses shared styles. It is recommended that you
 * use shared styles *)
and document =
  { feature : feature_params ;
    schemas : Schema.t list ;
    features : feature list }

and feature =
  | Document of document
  | Folder of folder
  | NetworkLink of NetworkLink.t
  | Placemark of Placemark.t
  | GroundOverlay of GroundOverlay.t
  | PhotoOverlay of PhotoOverlay.t
  | ScreenOverlay of ScreenOverlay.t

module Folder =
struct
  type t = folder
end

module Document =
struct
  type t = document
end

(* Specifies an addition, change, or deletion to KML data that has already been
 * loaded using the specified URL. The <targetHref> specifies the .kml or .kmz
 * file whose data (within Google Earth) is to be modified. <Update> is always
 * contained in a NetworkLinkControl. Furthermore, the file containing the
 * NetworkLinkControl must have been loaded by a NetworkLink. See the "Topics
 * in KML" page on Updates for a detailed example of how Update works.
 *
 * Can contain any number of <Change>, <Create>, and <Delete> elements, which
 * will be processed in order. *)
type update =
  { changes : (update_operation * (*kml_data*) unit) array }
and update_operation = Change | Create | Delete

(* You can control the snippet for the network link from the server, so that
 * changes made to the snippet on the client side are overridden by the server.
 * <linkSnippet> has a maxLines attribute, an integer that specifies the
 * maximum number of lines to display. *)
type link_snippet =
  { max_lines : int option ;
    text : string }

module NetworkLinkControl =
struct
  (* Controls the behavior of files fetched by a <NetworkLink>. *)
  type t =
    { (* Specified in seconds, <minRefreshPeriod> is the minimum allowed time
         between fetches of the file. This parameter allows servers to throttle
         fetches of a particular file and to tailor refresh rates to the expected
         rate of change to the data. For example, a user might set a link refresh
         to 5 seconds, but you could set your minimum refresh period to 3600 to
         limit refresh updates to once every hour. *)
      min_refresh_period : float ;
      (* Specified in seconds, <maxSessionLength> is the maximum amount of time
       * for which the client NetworkLink can remain connected. The default value
       * of -1 indicates not to terminate the session explicitly. *)
      max_session_length : float ;
      (* Use this element to append a string to the URL query on the next refresh
       * of the network link. You can use this data in your script to provide
       * more intelligent handling on the server side, including version querying
       * and conditional file delivery. *)
      cookie : string option ;
      (* You can deliver a pop-up message, such as usage guidelines for your
       * network link. The message appears when the network link is first loaded
       * into Google Earth, or when it is changed in the network link control. *)
      message : string option ;
      (* You can control the name of the network link from the server, so that
       * changes made to the name on the client side are overridden by the
       * server. *)
      link_name : string option ;
      (* You can control the description of the network link from the server, so
       * that changes made to the description on the client side are overridden
       * by the server. *)
      link_description : string option ;
      link_snippet : link_snippet option ;
      (* You can specify a date/time at which the link should be refreshed. This
       * specification takes effect only if the <refreshMode> in <Link> has a
       * value of onExpire. See <refreshMode> *)
      expires : date_time option ;
      (* With <Update>, you can specify any number of Change, Create, and Delete
       * tags for a .kml file or .kmz archive that has previously been loaded
       * with a network link. See <Update>. *)
      update : update option ;
      abstract_view : abstract_view option }
end

type kml =
  { hint : string option ;
    feature : feature option ;
    network_link_control : NetworkLinkControl.t option }
