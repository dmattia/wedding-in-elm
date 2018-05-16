module Data.Event exposing (Model, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)

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

decoder : Decoder Model
decoder =
  decode Model
    |> required "address" Decode.string
    |> required "directionsLink" Decode.string
    |> required "location" Decode.string
    |> required "marker" mapMarkerDecoder
    |> required "time" Decode.string
    |> required "title" Decode.string

mapMarkerDecoder : Decoder MapMarker
mapMarkerDecoder =
  decode MapMarker
    |> required "icon" Decode.string
    |> required "infoText" Decode.string
    |> required "position" positionDecoder
    |> required "title" Decode.string

positionDecoder : Decoder Position
positionDecoder =
  decode Position
    |> required "lat" Decode.float
    |> required "lng" Decode.float
