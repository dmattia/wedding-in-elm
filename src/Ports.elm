port module Ports exposing (onContentFetch)

import Json.Encode exposing (Value)

port onContentFetch : (Value -> msg) -> Sub msg
