module Main exposing (..)

import Browser exposing (Document, UrlRequest(..), application)
import Browser.Navigation as Nav
import Data.Content as Content exposing (Model)
import Data.Event as Event
import Data.Msg exposing (Msg(..))
import Data.Pages exposing (CurrentPage(..))
import Html exposing (Html, div, h1, hr, img, span, text)
import Html.Attributes
import Json.Decode as Decode exposing (Value)
import Json.Encode as E
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
    , key : Nav.Key
    }


init : flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    Model Nothing Blank key
        |> setRoute (Route.fromUrl url)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( SetContent (Just content), Events ) ->
            ( { model | content = Just content }
            , Ports.loadMap (Content.mapInfoEncoder content)
            )

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

        ( LeaveSite externalUrl, _ ) ->
            ( model, Nav.load externalUrl )

        ( ChangePage url, _ ) ->
            ( model
            , Nav.pushUrl model.key (Url.toString url)
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
                    ( { model | page = Events }
                    , case model.content of
                        Just content ->
                            Ports.loadMap (Content.mapInfoEncoder content)

                        Nothing ->
                            Cmd.none
                    )

                Route.Travel ->
                    ( { model | page = Travel }, Cmd.none )

                Route.Rsvp ->
                    ( { model | page = Rsvp Pages.Rsvp.initialModel }, initMaterialSelects "all" )

                Route.Party ->
                    ( { model | page = Party }, Cmd.none )

                Route.Registry ->
                    ( { model | page = Registry }, Cmd.none )


titleForPage : CurrentPage -> String
titleForPage currentPage =
    case currentPage of
        Blank ->
            "Secret blank page"

        Home ->
            "Home"

        Events ->
            "Events"

        Party ->
            "Party"

        Registry ->
            "Registry"

        Rsvp _ ->
            "Rsvp"

        Travel ->
            "Travel"

        NotFound ->
            "Secret 404 page"


view : Model -> Document Msg
view model =
    Document
        (titleForPage model.page)
        [ viewHtml model ]


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
    application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = onUrlRequest
        , onUrlChange = onUrlChange
        }


onUrlRequest : UrlRequest -> Msg
onUrlRequest request =
    case request of
        Internal url ->
            ChangePage url

        External url ->
            LeaveSite url


onUrlChange : Url -> Msg
onUrlChange url =
    SetRoute (Route.fromUrl url)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map SetContent contentChange


contentChange : Sub (Maybe Content.Model)
contentChange =
    Ports.onContentFetch (Decode.decodeValue Content.decoder >> Result.toMaybe)
