module Pages.Events exposing (view)

import Data.Event as Event
import Html exposing (Html, a, br, div, h1, h5, hr, img, p, text)
import Html.Attributes exposing (alt, attribute, class, href, id, src)
import Html.Events exposing (on, onClick)
import Json.Decode as Json
import Material exposing (inRow, spinner)


view : List Event.Model -> Html msg
view events =
    div [ class "events row" ]
        [ div [ class "row col s12 m6 push-m6" ]
            [ mapView events
            ]
        , div [ class "row col s12 m6 pull-m6" ]
            [ listView events
            ]
        ]


mapView : List Event.Model -> Html msg
mapView events =
    div [ id "map", class "map" ] []


listView : List Event.Model -> Html msg
listView events =
    div [] <|
        List.intersperse (hr [] []) <|
            List.map eventView events


eventView : Event.Model -> Html msg
eventView event =
    div []
        [ h5 [ class "header" ] [ text event.title ]
        , p [ class "flow-text" ]
            [ text event.time
            , br [] []
            , text event.location
            , br [] []
            , text event.address
            ]
        , a [ href event.directionsLink ] [ text "Get Directions" ]
        ]
