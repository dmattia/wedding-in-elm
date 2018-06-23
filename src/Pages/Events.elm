module Pages.Events exposing (Msg, update, view)

import Data.Event as Event
import Html exposing (Html, a, br, div, h1, h5, hr, img, p, text)
import Html.Attributes exposing (alt, attribute, class, href, id, src)
import Html.Events exposing (on, onClick)
import Json.Decode as Json
import Material exposing (inRow, spinner)


type Msg
    = ClickedMarker Event.MapMarker


update : Msg -> Cmd Msg
update msg =
    case msg of
        ClickedMarker marker ->
            Cmd.none


view : List Event.Model -> Html Msg
view events =
    div [ class "events row" ]
        [ div [ class "row col s12 m6 push-m6" ]
            [ mapView events
            ]
        , div [ class "row col s12 m6 pull-m6" ]
            [ listView events
            ]
        ]


mapView : List Event.Model -> Html Msg
mapView events =
    let
        mapCenter =
            centerOfEvents events
    in
    Html.node "google-map"
        [ class "map"
        , attribute "latitude" (String.fromFloat mapCenter.lat)
        , attribute "longitude" (String.fromFloat mapCenter.lng)
        , attribute "zoom" "9"
        , attribute "api-key" "AIzaSyD3E1D9b-Z7ekrT3tbhl_dy8DCXuIuDDRc"
        ]
    <|
        mapMarkers (List.map .marker events)


mapMarkers : List Event.MapMarker -> List (Html Msg)
mapMarkers markers =
    List.map markerView markers


markerView : Event.MapMarker -> Html Msg
markerView marker =
    Html.node "google-map-marker"
        [ attribute "latitude" (String.fromFloat marker.position.lat)
        , attribute "longitude" (String.fromFloat marker.position.lng)
        , attribute "icon" marker.icon
        , attribute "clickEvents" "true"
        , attribute "slot" "markers"
        , on "google-map-marker-click" <|
            Json.succeed <|
                ClickedMarker marker
        ]
        [ text marker.infoText
        ]


listView : List Event.Model -> Html Msg
listView events =
    div [] <|
        List.intersperse (hr [] []) <|
            List.map eventView events


eventView : Event.Model -> Html Msg
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


centerOfEvents : List Event.Model -> Event.Position
centerOfEvents events =
    List.map .marker events
        |> List.map .position
        |> Event.findCenter
