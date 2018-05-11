module Pages.Home exposing (view, Msg, update)

import Html exposing (Html, h1, text, img, div)
import Html.Attributes exposing (src, class, alt, attribute, id)
import Html.Events exposing (onClick)
import Material exposing (inRow, materialBox)

type Msg
  = Noop

update : Msg -> Cmd Msg
update msg =
  Cmd.none

view : Html Msg
view =
  inRow <|
    [ div [ class "col s10 offset-s1 m8 offset-m2" ]
        [
          img
            [ class "responsive-img" 
            , src imgSrc
            , alt "Photo of David and Bri"
            , attribute "data-caption" "Photo by Alicia Morris"
            ] []
        ]
    ]

imgSrc : String
imgSrc = "https://davidandbri.com/_nuxt/img/hiking.3a22c01.jpg"
