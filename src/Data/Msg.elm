module Data.Msg exposing (Msg, Msg(..))

import Route exposing (Route)
import Data.Content as Content exposing (Content)
import Pages.Home exposing (Msg)

type Msg
    = SetRoute (Maybe Route)
    | SetContent Content
    | OpenSideNav
    | HomeMsg Pages.Home.Msg
