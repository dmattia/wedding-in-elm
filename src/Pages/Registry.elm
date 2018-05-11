module Pages.Registry exposing (view)

import Html exposing (Html, div, p)
import Html.Attributes exposing (class)
import Material exposing (inRow)
import Data.Registry as Model
import UI

view : Model.Registry -> Html msg
view model =
  div []
    [ viewSection model.rmhc
    , viewSection model.amazon
    ]

viewSection : Model.Section -> Html msg
viewSection section =
  div []
    [ p [ class "flow-text" ] [ UI.rawHtml section.text ]
    , UI.wideLink section.link section.linkText
    ]
