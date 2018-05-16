module Pages.Party exposing (view)

import Html exposing (Html, div, img, p, text)
import Html.Attributes exposing (class, src)
import Material exposing (inRow, spinner)
import Data.PartyMember as PartyMember
import UI

view : Maybe (List PartyMember.Model) -> Html msg
view model =
  case model of
    Just members ->
      viewMembers members

    Nothing ->
      spinner

viewMembers : List PartyMember.Model -> Html msg
viewMembers members =
  div [ class "party" ] 
    <| [ inRow <| List.map viewMember members ]

viewMember : PartyMember.Model -> Html msg
viewMember member =
  div [ class "col s12 m4 person" ]
    [ inRow [ fittedImage member.imageUrl ]
    , div [ class "center" ]
      [ UI.flowText member.name
      , p [] [ text member.title ]
      ]
    ]

fittedImage : String -> Html msg
fittedImage imgSrc =
  div [ class "col s12 m8 offset-m2" ]
    [ img [ src imgSrc, class "partyImage" ] []
    ]
