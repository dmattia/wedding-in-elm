module Data.Msg exposing (Msg(..))

import Data.Content as Content
import Pages.Home exposing (Msg)
import Pages.Rsvp exposing (Msg)
import Route exposing (Route)
import Url exposing (Url)


type Msg
    = SetRoute (Maybe Route)
    | SetContent (Maybe Content.Model)
    | OpenSideNav
    | LeaveSite String
    | ChangePage Url
    | HomeMsg Pages.Home.Msg
    | RsvpMsg Pages.Rsvp.Msg
