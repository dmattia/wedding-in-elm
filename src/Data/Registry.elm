module Data.Registry exposing (Model, Section, decoder)

import Json.Decode as Decode exposing (Decoder)


--import Json.Decode.Pipeline exposing (required)


type alias Model =
    { amazon : Section
    , ronaldMcDonaldHouse : Section
    }


type alias Section =
    { paragraphs : List String
    , link : String
    , linkText : String
    }



{--
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
--}


decoder : Decoder Model
decoder =
    Decode.map2 Model
        (Decode.field "amazon" sectionDecoder)
        (Decode.field "rmhc" sectionDecoder)


sectionDecoder : Decoder Section
sectionDecoder =
    Decode.map3 Section
        (Decode.field "paragraphs" <| Decode.list Decode.string)
        (Decode.field "link" Decode.string)
        (Decode.field "linkText" Decode.string)
