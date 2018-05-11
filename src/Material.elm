port module Material exposing (inRow, openSideNav, materialBox, inContainer)

import Html exposing (Html, div)
import Html.Attributes exposing (class)

inContainer : List (Html msg) -> Html msg
inContainer =
  div [ class "container" ]

inRow : List (Html msg) -> Html msg
inRow =
  div [ class "row" ]

port openSideNav: () -> Cmd msg

port materialBox: String -> Cmd msg
