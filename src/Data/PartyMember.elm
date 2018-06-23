module Data.PartyMember exposing (Model, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)

type alias Model =
  { imageUrl: String
  , name: String
  , title: String
  }

decoder : Decoder Model
decoder =
  Decode.succeed Model
    |> required "image" Decode.string
    |> required "name" Decode.string
    |> required "title" Decode.string
