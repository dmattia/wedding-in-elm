module Pages.Registry exposing (view)

import Html exposing (Html, div, p, text, br)
import Html.Attributes exposing (class)
import Material exposing (inRow, spinner)
import Data.Registry as Registry
import UI

view : Registry.Model -> Html msg
view model =
  div []
    [ viewSection model.ronaldMcDonaldHouse
    , viewSection model.amazon
    ]

viewSection : Registry.Section -> Html msg
viewSection section =
  div []
    [ div [] <| List.map flowyParagraph section.paragraphs
    , UI.wideLink section.link section.linkText
    ]

flowyParagraph : String -> Html msg
flowyParagraph content =
  p [ class "flow-text" ] [ text content ]
