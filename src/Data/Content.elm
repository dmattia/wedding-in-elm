module Data.Content exposing (Model, decoder)

import Data.Event as Event
import Data.PartyMember as PartyMember
import Data.Registry as Registry
import Data.Travel as Travel

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)

type alias Model =
  { events: List Event.Model
  , party: List PartyMember.Model
  , registry: Registry.Model
  , travel: Travel.Model
  }

decoder : Decoder Model
decoder =
  Decode.succeed Model
    |> required "events" (Decode.list Event.decoder)
    |> required "party" (Decode.list PartyMember.decoder)
    |> required "registry" Registry.decoder
    |> required "travel" Travel.decoder
