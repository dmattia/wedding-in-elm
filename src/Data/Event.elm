module Data.Event exposing (Event)

type alias Event =
  { address: String
  , directionsLink: String
  , location: String
  , marker: MapMarker
  , time: String
  , title: String
  }

type alias MapMarker =
  { icon: String
  , infoText: String
  , position: Position
  , title: String
  }

type alias Position =
  { lat: Float
  , lng: Float
  }
