module Data.PartyMember exposing (Model, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)

type alias Model =
  { imageUrl: String
  , name: String
  , title: String
  }

decoder : Decoder Model
decoder =
  decode Model
    |> required "image" Decode.string
    |> required "name" Decode.string
    |> required "title" Decode.string
