port module Ports exposing (onContentFetch)

import Data.Content as Content exposing (Content)

port onContentFetch : (Content -> msg) -> Sub msg
