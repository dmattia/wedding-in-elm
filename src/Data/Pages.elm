module Data.Pages exposing (CurrentPage(..))

import Pages.Rsvp exposing (Model)

type CurrentPage
  = Blank
  | Home
  | Events
  | Party
  | Registry
  | Rsvp Pages.Rsvp.Model
  | Travel
  | NotFound
