module Pages.Party exposing (view)

import Html exposing (Html, div, img, p, text)
import Html.Attributes exposing (class, src)
import Material exposing (inRow)
import Data.PartyMember as Model
import UI

view : List Model.PartyMember -> Html msg
view members =
  div [ class "party" ] 
    <| [ inRow <| List.map viewMember members ]

viewMember : Model.PartyMember -> Html msg
viewMember member =
  div [ class "col s12 m4 person" ]
    [ inRow [ fittedImage member.image ]
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
