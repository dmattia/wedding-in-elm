module Data.Event exposing (Model, decoder, findCenter, Position, MapMarker)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)

type alias Model =
  { address: String
  , directionsLink: String
  , location: String
  , marker: MapMarker
  , time: String
  , title: String
  }

type alias MapMarker =
  { icon: String
  , infoText: String
  , position: Position
  , title: String
  }

type alias Position =
  { lat: Float
  , lng: Float
  }

-- TODO: check if len is 0
findCenter : List Position -> Position
findCenter positions =
  let
    len = toFloat <| List.length positions
  in 
    { lat = List.sum (List.map .lat positions) / len
    , lng = List.sum (List.map .lng positions) / len
    }

decoder : Decoder Model
decoder =
  Decode.succeed Model
    |> required "address" Decode.string
    |> required "directionsLink" Decode.string
    |> required "location" Decode.string
    |> required "marker" mapMarkerDecoder
    |> required "time" Decode.string
    |> required "title" Decode.string

mapMarkerDecoder : Decoder MapMarker
mapMarkerDecoder =
  Decode.succeed MapMarker
    |> required "icon" Decode.string
    |> required "infoText" Decode.string
    |> required "position" positionDecoder
    |> required "title" Decode.string

positionDecoder : Decoder Position
positionDecoder =
  Decode.succeed Position
    |> required "lat" Decode.float
    |> required "lng" Decode.float
