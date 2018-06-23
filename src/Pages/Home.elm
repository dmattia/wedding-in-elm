module Pages.Home exposing (Msg, update, view)

import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (alt, attribute, class, id, src)
import Html.Events exposing (onClick)
import Material exposing (inRow)


type Msg
    = Noop


update : Msg -> Cmd Msg
update msg =
    Cmd.none


view : Html Msg
view =
    inRow <|
        [ div [ class "col s10 offset-s1 m8 offset-m2" ]
            [ img
                [ class "responsive-img"
                , src imgSrc
                , alt "Photo of David and Bri"
                , attribute "data-caption" "Photo by Alicia Morris"
                ]
                []
            ]
        ]


imgSrc : String
imgSrc =
    "https://davidandbri.com/_nuxt/img/hiking.3a22c01.jpg"
