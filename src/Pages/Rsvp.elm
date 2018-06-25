module Pages.Rsvp exposing (Model, Msg, initialModel, update, view)

import Html exposing (Html, button, div, h1, i, img, input, label, option, select, span, text, ul)
import Html.Attributes exposing (alt, attribute, class, classList, disabled, for, id, selected, src, type_, value)
import Html.Events exposing (on, onClick, onInput, targetValue)
import Html.Keyed as Keyed
import Json.Decode as Json exposing (Decoder)
import Material exposing (inRow, initMaterialSelects, toast)


{--Model --}


type alias Model =
    { rsvps : List Entry
    , emailFormInfo : EmailFormInfo
    , pageStatus : PageStatus
    , nextEntryId : Int
    }


type PageStatus
    = AwaitingSubmission
    | Loading
    | SuccessfullySubmitted


type alias Email =
    String


type alias Error =
    String


type EmailFormInfo
    = WantsEmail Email
    | DoesNotWantEmail


type alias Entry =
    { id : Int
    , firstName : String
    , lastName : String
    , weddingOption : SelectOptions
    , transpoOption : SelectOptions
    , receptionOption : SelectOptions
    , errors : List Error
    }


type SelectOptions
    = Undecided
    | Going
    | NotGoing


type Msg
    = ToggleEmailSwitch
    | Submit
    | AddEntry
    | RemoveEntry Int
    | SetFirstName Int String
    | SetLastName Int String
    | SetAttendingReception Int SelectOptions
    | SetAttendingWedding Int SelectOptions
    | SetWantsTransport Int SelectOptions
    | SetErrors Int (List Error)


initialModel : Model
initialModel =
    { rsvps = [ newEntry 0 ]
    , emailFormInfo = DoesNotWantEmail
    , pageStatus = AwaitingSubmission
    , nextEntryId = 1
    }


newEntry : Int -> Entry
newEntry id =
    { firstName = ""
    , lastName = ""
    , weddingOption = Undecided
    , transpoOption = Undecided
    , receptionOption = Undecided
    , errors = []
    , id = id
    }



{--Update --}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleEmailSwitch ->
            ( toggleEmailSwitch model
            , Cmd.none
            )

        AddEntry ->
            ( addNewEntry model
            , initMaterialSelects "added new entry"
            )

        RemoveEntry index ->
            if List.length model.rsvps == 1 then
                ( model, toast "Cannot remove last guest" )
            else
                ( removeEntry index model
                , Cmd.none
                )

        SetFirstName index value ->
            ( model |> updateRsvp index (setFirstName value)
            , Cmd.none
            )

        SetLastName index value ->
            ( model |> updateRsvp index (setLastName value)
            , Cmd.none
            )

        SetAttendingReception index value ->
            ( model |> updateRsvp index (setAttendingReception value)
            , Cmd.none
            )

        SetAttendingWedding index value ->
            ( model |> updateRsvp index (setAttendingWedding value)
            , Cmd.none
            )

        SetWantsTransport index value ->
            ( model |> updateRsvp index (setWantsTransport value)
            , Cmd.none
            )

        SetErrors index errors ->
            ( model |> updateRsvp index (setErrors errors)
            , Cmd.none
            )

        Submit ->
            let
                validatedModel =
                    validateModel model
            in
            if isValid validatedModel then
                ( validatedModel, toast "Sending a post request, bitch" )
            else
                ( validatedModel, toast "Please fix errors marked under each RSVP card" )


{-| Checks if a model is fully valid and ready to be submitted.
-}
isValid : Model -> Bool
isValid model =
    model
        |> .rsvps
        |> List.map .errors
        |> List.all List.isEmpty


validateModel : Model -> Model
validateModel model =
    model
        |> setRsvps (List.map validateEntry model.rsvps)


validateEntry : Entry -> Entry
validateEntry rsvp =
    let
        errors =
            validateAll
                [ ( String.isEmpty rsvp.firstName, "You must enter a first name" )
                , ( String.isEmpty rsvp.lastName, "You must enter a last name" )
                , ( rsvp.weddingOption == Undecided, "You must select an option for attending the wedding" )
                , ( rsvp.receptionOption == Undecided, "You must select an option for attending the reception" )
                , ( rsvp.receptionOption == Going && rsvp.transpoOption == Undecided
                  , "You must select a transportation option if you plan to attend the reception"
                  )
                ]
    in
    setErrors errors rsvp


validateAll : List ( Bool, Error ) -> List Error
validateAll validations =
    validations
        |> List.filter Tuple.first
        |> List.map Tuple.second


setErrors : List Error -> Entry -> Entry
setErrors errors entry =
    { entry | errors = errors }


setRsvps : List Entry -> Model -> Model
setRsvps newRsvps model =
    { model | rsvps = newRsvps }


removeEntry : Int -> Model -> Model
removeEntry index model =
    model
        |> setRsvps (removeAt index model.rsvps)


removeAt : Int -> List a -> List a
removeAt i xs =
    List.take i xs ++ List.drop (i + 1) xs


updateAt : Int -> (a -> a) -> List a -> List a
updateAt index func xs =
    let
        updateIfIndex i elem =
            if i == index then
                func elem
            else
                elem
    in
    List.indexedMap updateIfIndex xs


incrementNextEntryId : Model -> Model
incrementNextEntryId model =
    { model | nextEntryId = model.nextEntryId + 1 }


addNewEntry : Model -> Model
addNewEntry model =
    model
        |> setRsvps (model.rsvps ++ [ newEntry model.nextEntryId ])
        |> incrementNextEntryId


setFirstName : String -> Entry -> Entry
setFirstName name entry =
    { entry | firstName = name }


setLastName : String -> Entry -> Entry
setLastName name entry =
    { entry | lastName = name }


setAttendingReception : SelectOptions -> Entry -> Entry
setAttendingReception option entry =
    { entry | receptionOption = option }


setAttendingWedding : SelectOptions -> Entry -> Entry
setAttendingWedding option entry =
    { entry | weddingOption = option }


setWantsTransport : SelectOptions -> Entry -> Entry
setWantsTransport option entry =
    { entry | transpoOption = option }


updateRsvp : Int -> (Entry -> Entry) -> Model -> Model
updateRsvp index f model =
    model
        |> setRsvps (updateAt index f model.rsvps)


toggleEmailSwitch : Model -> Model
toggleEmailSwitch model =
    let
        emailFormInfo =
            case model.emailFormInfo of
                WantsEmail someEmail ->
                    DoesNotWantEmail

                DoesNotWantEmail ->
                    WantsEmail ""
    in
    { model | emailFormInfo = emailFormInfo }



{--View --}


view : Model -> Html Msg
view model =
    case model.pageStatus of
        AwaitingSubmission ->
            rsvpForm model

        Loading ->
            Material.spinner

        SuccessfullySubmitted ->
            successfulView


rsvpForm : Model -> Html Msg
rsvpForm model =
    div []
        [ Html.p [ class "flow-text center" ] [ text rsvpMessage ]
        , rsvpInputs model.rsvps
        , addGuestButton
        , emailForm model.emailFormInfo
        , submitButton
        ]


rsvpInputs : List Entry -> Html Msg
rsvpInputs entries =
    Keyed.node "div" [] <| List.indexedMap keyedRsvpInput entries


keyedRsvpInput : Int -> Entry -> ( String, Html Msg )
keyedRsvpInput index entry =
    ( String.fromInt entry.id
    , rsvpInput index entry
    )


rsvpInput : Int -> Entry -> Html Msg
rsvpInput index entry =
    div [ class "row guest-form" ]
        [ closeButton index
        , div [ class "input-field col s12 m5 pull-m1" ]
            [ input
                [ type_ "text"
                , onInput <| SetFirstName index
                , value entry.firstName
                , id <| getInputId "first-name" index
                ]
                []
            , label [ for <| getInputId "first-name" index ] [ text <| getTitle index ++ " First Name" ]
            ]
        , div [ class "input-field col s12 m5 pull-m1" ]
            [ input
                [ type_ "text"
                , onInput <| SetLastName index
                , value entry.lastName
                , id <| getInputId "last-name" index
                ]
                []
            , label [ for <| getInputId "last-name" index ] [ text <| getTitle index ++ " Last Name" ]
            ]
        , div [ class "input-field col s12" ]
            [ div [ class "material-select" ]
                [ select [ on "change" <| optionsDecoder <| SetAttendingWedding index ] weddingOptions
                ]
            ]
        , div [ class "input-field col s12" ]
            [ div [ class "material-select" ]
                [ select [ on "change" <| optionsDecoder <| SetAttendingReception index ] receptionOptions
                ]
            ]
        , div [ class "input-field col s12", classList [ ( "hide", entry.receptionOption /= Going ) ] ]
            [ div [ class "material-select" ]
                [ select [ on "change" <| optionsDecoder <| SetWantsTransport index ] transpoOptions
                ]
            ]
        , ul [ class "col s12 browser-default hide-on-med-and-up" ] <|
            List.map
                (\error -> span [ class "main-color" ] [ text error ])
                entry.errors
        , div [ class "col s12 hide-on-small-only" ] <|
            List.map
                (\error -> div [ class "chip" ] [ text error ])
                entry.errors
        ]


optionsDecoder : (SelectOptions -> Msg) -> Decoder Msg
optionsDecoder partialMsg =
    targetValue
        |> Json.map stringToOption
        |> Json.map partialMsg


stringToOption : String -> SelectOptions
stringToOption s =
    case s of
        "Going" ->
            Going

        "NotGoing" ->
            NotGoing

        _ ->
            Undecided


optionToString : SelectOptions -> String
optionToString selectedOption =
    case selectedOption of
        Undecided ->
            "Undecided"

        Going ->
            "Going"

        NotGoing ->
            "NotGoing"


options : String -> String -> String -> List (Html Msg)
options defaultMsg goingMsg notGoingMsg =
    [ option [ value "Undecided", disabled True, selected True ] [ text defaultMsg ]
    , option [ value "Going" ] [ text goingMsg ]
    , option [ value "NotGoing" ] [ text notGoingMsg ]
    ]


weddingOptions : List (Html Msg)
weddingOptions =
    options
        "Wedding RSVP"
        "I will attend the wedding"
        "I can't make the wedding"


receptionOptions : List (Html Msg)
receptionOptions =
    options
        "Reception RSVP"
        "I will attend the reception"
        "I can't make the reception"


transpoOptions : List (Html Msg)
transpoOptions =
    options
        "Transportation RSVP"
        "I would like transportation to and from the reception (pickup/dropoff at SpringHill Suites)"
        "I don't need transportation"


getInputId : String -> Int -> String
getInputId prefix index =
    prefix ++ String.fromInt index


{-| Gets the title for a user given an index of their rsvp form. The first rsvp is assumed to be from the person filling out the rsvp.
-}
getTitle : Int -> String
getTitle index =
    if index == 0 then
        "Your"
    else
        "Guest's"


closeButton : Int -> Html Msg
closeButton index =
    div [ class "col s12 m1 push-m11" ]
        [ button [ class "btn-floating reverse-bg right", onClick <| RemoveEntry index ]
            [ i [ class "material-icons reverse-color" ] [ text "close" ]
            ]
        ]


emailForm : EmailFormInfo -> Html Msg
emailForm info =
    div [ class "row" ]
        [ div [ class "col s12" ]
            [ Html.label []
                [ Html.input [ type_ "checkbox", onClick ToggleEmailSwitch ] []
                , span [] [ text "Want to receive an email receipt?" ]
                ]
            , emailInput info
            ]
        ]


emailInput : EmailFormInfo -> Html Msg
emailInput info =
    case info of
        WantsEmail someEmail ->
            div [ class "input-field col s12" ]
                [ input [ id "email", type_ "email" ] []
                , label [ for "email" ] [ text "Email Address Receipt will be sent to" ]
                ]

        DoesNotWantEmail ->
            text ""


rsvpMessage : String
rsvpMessage =
    "You only need to RSVP once, either online or by mailing in the RSVP card."


addGuestButton : Html Msg
addGuestButton =
    div [ class "row" ]
        [ Html.button
            [ class "col s8 offset-s2 m4 offset-m4 reverse-color reverse-bg btn-large"
            , onClick AddEntry
            ]
            [ text "Add Guest"
            ]
        ]


submitButton : Html Msg
submitButton =
    div [ class "row" ]
        [ Html.button
            [ class "col s8 offset-s2 m4 offset-m4 reverse-color reverse-bg btn-large"
            , onClick Submit
            ]
            [ text "Submit"
            ]
        ]


successfulView : Html Msg
successfulView =
    Html.p [] [ text "success" ]
