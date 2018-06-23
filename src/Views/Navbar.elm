module Views.Navbar exposing (view)

import Html exposing (Html, h5, h4, p, text, div, i, button, ul, li, a, nav, hr)
import Html.Attributes exposing (class, classList, id)
import Html.Events exposing (onClick)
import Data.Pages as Page exposing (CurrentPage(..))
import Data.Msg exposing (Msg(..))
import Route exposing (Route)

import Pages.Rsvp exposing (initialModel)

type LinkType
  = Wide
  | Narrow

view: CurrentPage -> Html Msg
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

linkHtml : CurrentPage -> LinkType -> List (Html Msg)
linkHtml currentPage linkType =
  List.map (linkToHtml currentPage linkType) links

links : List (Route, String)
links =
  [ (Route.Home, "Home")
  , (Route.Events, "Events")
  , (Route.Travel, "Travel")
  , (Route.Rsvp, "RSVP")
  , (Route.Party, "Wedding Party")
  , (Route.Registry, "Registry")
  ]

pageMatchesRoute : CurrentPage -> Route -> Bool
pageMatchesRoute page route =
  case page of 
    Page.Home -> route == Route.Home
    Page.Events -> route == Route.Events
    Page.Travel -> route == Route.Travel
    Page.Rsvp _ -> route == Route.Rsvp
    Page.Party -> route == Route.Party
    Page.Registry -> route == Route.Registry
    Page.Blank -> False
    Page.NotFound -> False

linkToHtml : CurrentPage -> LinkType -> (Route, String) -> Html Msg
linkToHtml currentPage linkType (route, title) =
  li [ classList [("active", pageMatchesRoute currentPage route), ("wide", linkType == Wide)] ]
    [ a [ class "flow-text", Route.href route ] [ text title ]
    ]
