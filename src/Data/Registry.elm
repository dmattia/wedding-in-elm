module Data.Registry exposing (Model, decoder, Section)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)

type alias Model =
  { amazon: Section
  , ronaldMcDonaldHouse: Section
  }

type alias Section =
  { text: String
  , link: String
  , linkText: String
  }

decoder : Decoder Model
decoder =
  decode Model
    |> required "amazon" sectionDecoder
    |> required "rmhc" sectionDecoder

sectionDecoder : Decoder Section
sectionDecoder =
  decode Section
    |> required "text" Decode.string
    |> required "link" Decode.string
    |> required "linkText" Decode.string
