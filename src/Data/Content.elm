module Data.Content exposing (Model, decoder, mapInfoEncoder)

import Data.Event as Event
import Data.PartyMember as PartyMember
import Data.Registry as Registry
import Data.Travel as Travel
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as E


--import Json.Decode.Pipeline exposing (required)


type alias Model =
    { events : List Event.Model
    , party : List PartyMember.Model
    , registry : Registry.Model
    , travel : Travel.Model
    }



{--
decoder : Decoder Model
decoder =
  Decode.succeed Model
    |> required "events" (Decode.list Event.decoder)
    |> required "party" (Decode.list PartyMember.decoder)
    |> required "registry" Registry.decoder
    |> required "travel" Travel.decoder
--}


decoder : Decoder Model
decoder =
    Decode.map4 Model
        (Decode.field "events" <| Decode.list Event.decoder)
        (Decode.field "party" <| Decode.list PartyMember.decoder)
        (Decode.field "registry" Registry.decoder)
        (Decode.field "travel" Travel.decoder)


mapInfoEncoder : Model -> E.Value
mapInfoEncoder model =
    E.object
        [ ( "mapOptions", mapOptionsEncoder model.events )
        , ( "markers", E.list Event.encoder model.events )
        ]


mapOptionsEncoder : List Event.Model -> E.Value
mapOptionsEncoder events =
    E.object
        [ ( "center", Event.positionEncoder <| Event.centerOfEvents events )
        , ( "zoom", E.int 9 )
        ]
