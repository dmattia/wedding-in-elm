module Data.Travel exposing (Model, decoder)

import Json.Decode as Decode exposing (Decoder)


--import Json.Decode.Pipeline exposing (required)


type alias Model =
    { bookingLink : String
    , hotelCaption : String
    , hotelTitle : String
    , transpoTitle : String
    , transportation : String
    }



{--
decoder : Decoder Model
decoder =
  Decode.succeed Model
    |> required "bookingLink" Decode.string
    |> required "hotelCaption" Decode.string
    |> required "hotelTitle" Decode.string
    |> required "transpoTitle" Decode.string
    |> required "transportation" Decode.string
--}


decoder : Decoder Model
decoder =
    Decode.map5 Model
        (Decode.field "bookingLink" Decode.string)
        (Decode.field "hotelCaption" Decode.string)
        (Decode.field "hotelTitle" Decode.string)
        (Decode.field "transpoTitle" Decode.string)
        (Decode.field "transportation" Decode.string)
