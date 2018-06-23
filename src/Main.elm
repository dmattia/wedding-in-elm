module Main exposing (..)

import Browser exposing (Page)
import Browser.Navigation
import Data.Content as Content exposing (Model)
import Data.Msg exposing (Msg(..))
import Data.Pages exposing (CurrentPage(..))
import Html exposing (Html, div, h1, hr, img, span, text)
import Html.Attributes
import Json.Decode as Decode exposing (Value)
import Material as Material exposing (inContainer, initMaterialSelects, openSideNav)
import Pages.Events
import Pages.Home
import Pages.Party
import Pages.Registry
import Pages.Rsvp
import Pages.Travel
import Ports
import Route exposing (Route)
import Url exposing (Url)
import Views.Header
import Views.Navbar


type alias Model =
    { content : Maybe Content.Model
    , page : CurrentPage
    }


init : Browser.Env Value -> ( Model, Cmd Msg )
init { url, flags } =
    setRoute (Route.fromUrl url) (Model Nothing Blank)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( SetContent content, _ ) ->
            case content of
                Nothing ->
                    ( model, Cmd.none )

                Just someContent ->
                    ( { model | content = Just someContent }
                    , Cmd.none
                    )

        ( SetRoute route, _ ) ->
            setRoute route model

        ( OpenSideNav, _ ) ->
            ( model, openSideNav () )

        ( EventsMsg eventMsg, Events ) ->
            ( model, Cmd.none )

        ( HomeMsg homeMsg, Home ) ->
            ( model, Pages.Home.update homeMsg |> Cmd.map HomeMsg )

        ( RsvpMsg rsvpMsg, Rsvp rsvpModel ) ->
            let
                ( newRsvpModel, cmd ) =
                    Pages.Rsvp.update rsvpMsg rsvpModel
            in
            ( { model | page = Rsvp newRsvpModel }
            , Cmd.map RsvpMsg cmd
            )

        ( _, _ ) ->
            -- Disregard messages belonging to the incorrect page
            ( model, Cmd.none )


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    case maybeRoute of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just route ->
            case route of
                Route.Home ->
                    ( { model | page = Home }, Cmd.none )

                Route.Events ->
                    ( { model | page = Events }, Cmd.none )

                Route.Travel ->
                    ( { model | page = Travel }, Cmd.none )

                Route.Rsvp ->
                    --( { model | page = Rsvp Pages.Rsvp.initialModel }, Cmd.none )
                    ( { model | page = Rsvp Pages.Rsvp.initialModel }, initMaterialSelects "all" )

                Route.Party ->
                    ( { model | page = Party }, Cmd.none )

                Route.Registry ->
                    ( { model | page = Registry }, Cmd.none )


view : Model -> Page Msg
view model =
    Page "Some title" <| [ viewHtml model ]


viewHtml : Model -> Html Msg
viewHtml model =
    div []
        [ Views.Header.view
        , hr [] []
        , Views.Navbar.view model.page
        , hr [] []
        , inContainer <| [ viewPageContent model.page model.content ]
        ]


viewPageContent : CurrentPage -> Maybe Content.Model -> Html Msg
viewPageContent page content =
    case ( page, content ) of
        ( Home, _ ) ->
            Html.map HomeMsg Pages.Home.view

        ( Travel, Just context ) ->
            Pages.Travel.view context.travel

        ( Registry, Just context ) ->
            Pages.Registry.view context.registry

        ( Party, Just context ) ->
            Pages.Party.view context.party

        ( Events, Just context ) ->
            Pages.Events.view context.events
                |> Html.map EventsMsg

        ( Rsvp rsvpModel, _ ) ->
            Html.map RsvpMsg <| Pages.Rsvp.view rsvpModel

        ( Blank, _ ) ->
            text "Blank pages don't have content"

        ( NotFound, _ ) ->
            text "Route not found"

        ( _, Nothing ) ->
            Material.spinner


main : Program Value Model Msg
main =
    Browser.fullscreen
        { init = init
        , onNavigation = Just onNavigation
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


onNavigation : Url -> Msg
onNavigation url =
    SetRoute (Route.fromUrl url)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map SetContent contentChange


contentChange : Sub (Maybe Content.Model)
contentChange =
    Ports.onContentFetch (Decode.decodeValue Content.decoder >> Result.toMaybe)
