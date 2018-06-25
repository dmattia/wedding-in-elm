module Data.Event exposing (MapMarker, Model, Position, centerOfEvents, decoder, encoder, positionEncoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as E


--import Json.Decode.Pipeline exposing (required)


type alias Model =
    { address : String
    , directionsLink : String
    , location : String
    , marker : MapMarker
    , time : String
    , title : String
    }


type alias MapMarker =
    { icon : String
    , infoText : String
    , position : Position
    , title : String
    }


type alias Position =
    { lat : Float
    , lng : Float
    }



-- TODO: check if len is 0


centerOfEvents : List Model -> Position
centerOfEvents events =
    List.map .marker events
        |> List.map .position
        |> findCenter


findCenter : List Position -> Position
findCenter positions =
    let
        len =
            toFloat <| List.length positions
    in
    { lat = List.sum (List.map .lat positions) / len
    , lng = List.sum (List.map .lng positions) / len
    }



{--
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
--}


decoder : Decoder Model
decoder =
    Decode.map6 Model
        (Decode.field "address" Decode.string)
        (Decode.field "directionsLink" Decode.string)
        (Decode.field "location" Decode.string)
        (Decode.field "marker" mapMarkerDecoder)
        (Decode.field "time" Decode.string)
        (Decode.field "title" Decode.string)


mapMarkerDecoder : Decoder MapMarker
mapMarkerDecoder =
    Decode.map4 MapMarker
        (Decode.field "icon" Decode.string)
        (Decode.field "infoText" Decode.string)
        (Decode.field "position" positionDecoder)
        (Decode.field "title" Decode.string)


positionDecoder : Decoder Position
positionDecoder =
    Decode.map2 Position
        (Decode.field "lat" Decode.float)
        (Decode.field "lng" Decode.float)


encoder : Model -> E.Value
encoder model =
    mapMarkerEncoder model.marker


mapMarkerEncoder : MapMarker -> E.Value
mapMarkerEncoder mapMarker =
    E.object
        [ ( "title", E.string mapMarker.title )
        , ( "icon", E.string mapMarker.icon )
        , ( "infoText", E.string mapMarker.infoText )
        , ( "position", positionEncoder mapMarker.position )
        ]


positionEncoder : Position -> E.Value
positionEncoder position =
    E.object
        [ ( "lat", E.float position.lat )
        , ( "lng", E.float position.lng )
        ]
