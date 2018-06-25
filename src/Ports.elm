port module Ports exposing (loadMap, onContentFetch)

import Json.Encode exposing (Value)


port onContentFetch : (Value -> msg) -> Sub msg


port loadMap : Value -> Cmd msg
