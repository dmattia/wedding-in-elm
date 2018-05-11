module Data.Content exposing (Content)

import Data.Event as Event exposing (Event)
import Data.PartyMember as PartyMember exposing (PartyMember)
import Data.Registry as Registry exposing (Registry)
import Data.Travel as Travel exposing (Travel)

type alias Content =
  { events: List Event
  , party: List PartyMember
  , registry: Registry
  , travel: Travel
  }
