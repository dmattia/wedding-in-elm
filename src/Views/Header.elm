module Views.Header exposing (view)

import Html exposing (Html, h5, h4, p, text, div, i, button, ul, li, a)
import Html.Attributes exposing (class)

view : Html msg
view =
  div []
    [ p [ class "flow-text center" ] [ text "The Wedding Website of" ]
    , div [ class "hide-on-med-and-up" ]
      [ h5 [ class "center" ] [ text "Brianna" ]
      , h5 [ class "center" ] [ text "&" ]
      , h5 [ class "center" ] [ text "David" ]
      ]
    , div [ class "hide-on-small-only" ]
      [ h4 [ class "center" ] [ text "Brianna Kozemzak & David Mattia" ]
      ] 
    , p [ class "flow-text center" ] [ text "August 11, 2018" ]
    ]
