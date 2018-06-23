module Data.Registry exposing (Model, decoder, Section)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)

type alias Model =
  { amazon: Section
  , ronaldMcDonaldHouse: Section
  }

type alias Section =
  { paragraphs: List String
  , link: String
  , linkText: String
  }

decoder : Decoder Model
decoder =
  Decode.succeed Model
    |> required "amazon" sectionDecoder
    |> required "rmhc" sectionDecoder

sectionDecoder : Decoder Section
sectionDecoder =
  Decode.succeed Section
    |> required "paragraphs" (Decode.list Decode.string)
    |> required "link" Decode.string
    |> required "linkText" Decode.string
