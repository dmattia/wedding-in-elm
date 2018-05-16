module Data.Travel exposing (Model, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)

type alias Model =
  { bookingLink: String
  , hotelCaption: String
  , hotelTitle: String
  , transpoTitle: String
  , transportation: String
  }

decoder : Decoder Model
decoder =
  decode Model
    |> required "bookingLink" Decode.string
    |> required "hotelCaption" Decode.string
    |> required "hotelTitle" Decode.string
    |> required "transpoTitle" Decode.string
    |> required "transportation" Decode.string
