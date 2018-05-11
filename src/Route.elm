module Route exposing (Route(..), fromLocation, href)

import Html exposing (Attribute)
import Html.Attributes as Attr
import Navigation exposing (Location)
import UrlParser as Url exposing (Parser, oneOf, parseHash, s)

type Route
  = Home
  | Events
  | Travel
  | Rsvp 
  | Party
  | Registry

route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Home (s "")
        , Url.map Events (s "events")
        , Url.map Travel (s "travel")
        , Url.map Rsvp (s "rsvp")
        , Url.map Party (s "party")
        , Url.map Registry (s "registry")
        ]

routeToString : Route -> String
routeToString page =
    let
        url =
            case page of
                Home -> ""
                Events -> "events"
                Travel -> "travel"
                Rsvp -> "rsvp"
                Party -> "party"
                Registry -> "registry"
    in
    "#/" ++ url

href : Route -> Attribute msg
href route =
    Attr.href (routeToString route)

fromLocation : Location -> Maybe Route
fromLocation location =
    parseHash route location
