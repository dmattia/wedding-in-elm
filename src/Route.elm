module Route exposing (Route(..), fromUrl, href)

import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as UrlParser exposing (Parser, oneOf, s, top)

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
        [ UrlParser.map Home top
        , UrlParser.map Events (s "events")
        , UrlParser.map Travel (s "travel")
        , UrlParser.map Rsvp (s "rsvp")
        , UrlParser.map Party (s "party")
        , UrlParser.map Registry (s "registry")
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
    "/" ++ url

href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)

fromUrl : Url -> Maybe Route
fromUrl url =
  UrlParser.parse route url
