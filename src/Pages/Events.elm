module Pages.Events exposing (view, Msg, update)

import Html exposing (Html, h1, text, img, div, h5, br, p, a, hr)
import Html.Attributes exposing (src, class, alt, attribute, id, href)
import Html.Events exposing (onClick)
import Material exposing (inRow, materialBox, spinner)

import Data.Event as Event

type Msg
  = Noop

update : Msg -> Cmd Msg
update msg =
  Cmd.none

view : Maybe (List Event.Model) -> Html Msg
view model =
  case model of
    Just events ->
      withContentView events

    Nothing ->
      spinner

withContentView : List Event.Model -> Html Msg
withContentView model =
  div [ class "events row" ]
    [ div [ class "row col s12 m6 push-m6" ]
        [ mapView model
        ]
    , div [ class "row col s12 m6 pull-m6" ]
        [ listView model
        ]
    ]

mapView : List Event.Model -> Html Msg
mapView events =
  let 
    mapCenter = centerOfEvents events
  in
    Html.node "google-map"
      [ class "map" 
      , attribute "latitude" (toString mapCenter.lat)
      , attribute "longitude" (toString mapCenter.lng)
      ]
      []

listView : List Event.Model -> Html Msg
listView events =
  div []
    <| List.intersperse (hr [] [])
    <| List.map eventView events

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
