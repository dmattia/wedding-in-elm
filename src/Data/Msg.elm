module Data.Msg exposing (Msg(..))

import Route exposing (Route)
import Data.Content as Content
import Pages.Home exposing (Msg)
import Pages.Events exposing (Msg)
import Pages.Rsvp exposing (Msg)

type Msg
    = SetRoute (Maybe Route)
    | SetContent (Maybe Content.Model)
    | OpenSideNav
    | HomeMsg Pages.Home.Msg
    | EventsMsg Pages.Events.Msg
    | RsvpMsg Pages.Rsvp.Msg
