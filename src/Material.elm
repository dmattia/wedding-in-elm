port module Material exposing (inContainer, inRow, initMaterialSelects, openSideNav, spinner, toast)

import Html exposing (Html, div)
import Html.Attributes exposing (class, classList)


inContainer : List (Html msg) -> Html msg
inContainer =
    div [ class "container" ]


inRow : List (Html msg) -> Html msg
inRow =
    div [ class "row" ]


spinner : Html msg
spinner =
    div [ class "center" ]
        [ div [ class "preloader-wrapper active" ]
            [ subSpinner "spinner-blue"
            , subSpinner "spinner-red"
            , subSpinner "spinner-yellow"
            , subSpinner "spinner-green"
            ]
        ]


subSpinner : String -> Html msg
subSpinner color =
    div [ classList [ ( "spinner-layer", True ), ( color, True ) ] ]
        [ div [ class "circle-clipper left" ]
            [ div [ class "circle" ] []
            ]
        , div [ class "gap-patch" ]
            [ div [ class "circle" ] []
            ]
        , div [ class "circle-clipper right" ]
            [ div [ class "circle" ] []
            ]
        ]


port openSideNav : () -> Cmd msg


port initMaterialSelects : String -> Cmd msg


port toast : String -> Cmd msg
