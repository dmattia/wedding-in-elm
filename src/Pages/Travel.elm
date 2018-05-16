module Pages.Travel exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class)
import Data.Travel as Travel
import Material exposing (spinner)
import UI

view : Maybe Travel.Model -> Html msg
view model =
  case model of
    Just info ->
      withContentView info

    Nothing ->
      spinner

withContentView : Travel.Model -> Html msg
withContentView model =
  div []
    [ section model.hotelTitle model.hotelCaption
    , UI.wideLink model.bookingLink "Book now"
    , section model.transpoTitle model.transportation
    ]

section : String -> String ->  Html msg
section title caption =
  div [ class "row" ]
    [ h5 [ class "header" ] [ text title ]
    , UI.flowText caption
    ]
