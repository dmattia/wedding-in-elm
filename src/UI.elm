module UI exposing (wideLink, flowText)

import Html exposing (Html, a, text, div, p, span)
import Html.Attributes exposing (class, href, property)
import Json.Encode exposing (string)

wideLink : String -> String -> Html msg
wideLink link textContent =
  div [ class "row" ]
    [ a [ class "col reverse-color reverse-bg btn-large s8 offset-s2 m4 offset-m4"
        , href link
        ]
        [ text textContent ]
    ]

flowText : String -> Html msg
flowText textContent =
  p [ class "flow-text" ] [ text textContent ]
