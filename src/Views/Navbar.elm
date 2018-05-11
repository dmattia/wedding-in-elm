module Views.Navbar exposing (view)

import Html exposing (Html, h5, h4, p, text, div, i, button, ul, li, a, nav, hr)
import Html.Attributes exposing (class, classList, id)
import Html.Events exposing (onClick)
import Css exposing (..)
import Data.Pages as Page exposing (Page(..))
import Data.Msg exposing (Msg(..))
import Route exposing (Route)

type LinkType
  = Wide
  | Narrow

view: Page -> Html Msg
view currentPage =
  div [ class "navbar" ]
    [ nav [ class "transparent" ]
      [ div [ class "nav-wrapper" ]
        [ button [ class "main-color transparent borderless hide-on-large-only", onClick OpenSideNav ]
          [ i [ class "material-icons inline"] [ text "menu" ]
          , h5 [ class "inline", id "menuText" ] [ text "MENU" ]
          ]
        , ul [ class "center hide-on-med-and-down" ] <| linkHtml currentPage Narrow
        ]
      ]
    , ul [ class "sidenav" ] <| linkHtml currentPage Wide
    ]

linkHtml : Page -> LinkType -> List (Html Msg)
linkHtml currentPage linkType =
  List.map (linkToHtml currentPage linkType) links

links : List (Route, String, Page)
links =
  [ (Route.Home, "Home", Page.Home)
  , (Route.Events, "Events", Page.Events)
  , (Route.Travel, "Travel", Page.Travel)
  , (Route.Rsvp, "RSVP", Page.Rsvp)
  , (Route.Party, "Wedding Party", Page.Party)
  , (Route.Registry, "Registry", Page.Registry)
  ]

linkToHtml : Page -> LinkType -> (Route, String, Page) -> Html Msg
linkToHtml currentPage linkType (route, title, page) =
  li [ classList [("active", currentPage == page), ("wide", linkType == Wide)] ]
    [ a [ class "flow-text", Route.href route ] [ text title ]
    ]
