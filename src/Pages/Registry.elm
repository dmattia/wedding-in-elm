module Pages.Registry exposing (view)

import Html exposing (Html, div, p)
import Html.Attributes exposing (class)
import Material exposing (inRow, spinner)
import Data.Registry as Registry
import UI

view : Maybe Registry.Model -> Html msg
view model =
  case model of
    Just info ->
      withContentView info

    Nothing ->
      spinner

withContentView : Registry.Model -> Html msg
withContentView model =
  div []
    [ viewSection model.ronaldMcDonaldHouse
    , viewSection model.amazon
    ]

viewSection : Registry.Section -> Html msg
viewSection section =
  div []
    [ p [ class "flow-text" ] [ UI.rawHtml section.text ]
    , UI.wideLink section.link section.linkText
    ]
