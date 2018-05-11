module Data.Registry exposing (Registry, Section)

type alias Registry =
  { amazon: Section
  , rmhc: Section
  }

type alias Section =
  { text: String
  , link: String
  , linkText: String
  }
