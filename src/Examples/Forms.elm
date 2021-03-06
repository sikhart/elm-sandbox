module Examples.Forms exposing (main)

import Browser
import Html exposing (Html, div, text, input)
import Html.Attributes exposing (style, type_, placeholder, value)
import Html.Events exposing (onInput)


main : Program () Model Msg
main =
  Browser.sandbox { init = init, update = update, view = view }


type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  }


init : Model
init =
  Model "" "" ""


type Msg
  = Name String
  | Password String
  | PasswordAgain String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }
    Password password ->
      { model | password = password }
    PasswordAgain password ->
      { model | passwordAgain = password }


view : Model -> Html Msg
view model =
    div []
      [ viewInput "text" "Name" model.name Name
      , viewInput "password" "Password" model.password Password
      , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
      , viewValidation model
      ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []


viewValidation : Model -> Html msg
viewValidation model =
  if String.length model.password < 8 then
    div [ style "color" "red" ] [ text "Password too short!" ] 
  else if not (String.any Char.isLower model.password) 
    || not (String.any Char.isUpper model.password)
    || not (String.any Char.isDigit model.password) then
    div [ style "color" "red" ] [ text "Password must contain upper and lower case!" ] 
  else if model.password /= model.passwordAgain then
    div [ style "color" "red" ] [ text "Passwords do not match!" ] 
  else
    div [ style "color" "green" ] [ text "OK" ]
