module Main exposing (..)

import Html exposing (Html, text, div, h1, img, span, hr)
import Html.Attributes
import Data.Content as Content exposing (Content)
import Json.Decode as Decode exposing (Value)
import Navigation exposing (Location)
import Ports
import Route exposing (Route)

import Data.Msg exposing (Msg(..))
import Data.Pages exposing (Page(..))
import Pages.Home
import Pages.Travel
import Pages.Registry
import Pages.Party

import Views.Navbar
import Views.Header
import Material as Material exposing (openSideNav, inContainer)

type alias Model =
  { content: Maybe Content
  , page: Page
  }

init : Location -> ( Model, Cmd Msg )
init location =
  setRoute (Route.fromLocation location) (Model Nothing Blank) ! []

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SetContent content ->
      { model | content = Just content } ! []

    SetRoute route ->
      setRoute route model ! []

    OpenSideNav ->
      model ! [ openSideNav () ]

    HomeMsg msg ->
      model ! [ Pages.Home.update msg |> Cmd.map HomeMsg ]

setRoute : Maybe Route -> Model -> Model
setRoute maybeRoute model =
  case maybeRoute of
    Nothing ->
      { model | page = NotFound }
  
    Just route ->
      case route of
        Route.Home ->
          { model | page = Home }

        Route.Events ->
          { model | page = Events }

        Route.Travel ->
          { model | page = Travel }

        Route.Rsvp ->
          { model | page = Rsvp }

        Route.Party ->
          { model | page = Party }

        Route.Registry ->
          { model | page = Registry }

view : Model -> Html Msg
view model =
  case model.content of
    Just content ->
      div []
        [ Views.Header.view
        , hr [] []
        , Views.Navbar.view model.page
        , hr [] []
        , inContainer <| [ viewPageContent model.page content ]
        ]

    Nothing ->
      div []
        [ h1 [] [ text "Loading..." ]
        ]

viewPageContent : Page -> Content -> Html Msg
viewPageContent page content =
  case page of
    Home -> Pages.Home.view
      |> Html.map HomeMsg 

    Travel -> Pages.Travel.view content.travel

    Registry -> Pages.Registry.view content.registry

    Party -> Pages.Party.view content.party

    _ ->
      div []
        [ h1 [] [ text "some text for a page not in viewPageContent" ]
        ]

main : Program Never Model Msg
main =
    Navigation.program (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

subscriptions : Model -> Sub Msg
subscriptions model =
  Ports.onContentFetch SetContent
