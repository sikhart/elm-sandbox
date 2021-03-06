module Examples.Dice exposing (main)

import Browser
import Html exposing (Html, div, button)
import Html.Events exposing (onClick)
import Random
import Svg exposing (Svg, svg, circle)
import Svg.Attributes exposing (width, height, viewBox, cx, cy, r)


main : Program () Model Msg
main =
  Browser.element
  { init = init
  , update = update
  , subscriptions = subscriptions
  , view = view
  }

type alias Die =
  { face : Int
  , x : Int
  , y : Int
  , size : Int
  }

type alias Model = Die


init : () -> (Model, Cmd Msg)
init _ =
  ( Die 1 0 0 120
  , Cmd.none
  )


type Msg
  = Roll
  | NewFace Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
  Roll ->
    ( model
    , Random.generate NewFace (Random.int 1 6)
    )

  NewFace newFace ->
    ( { model | face = newFace }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none

drawCircle : Int -> Int -> Int -> Svg msg
drawCircle x y rad =
  circle
  [ cx (String.fromInt x)
  , cy (String.fromInt y)
  , r (String.fromInt rad) ] []


drawCircles : Int -> Int -> List (Svg msg)
drawCircles size n =
  let
    c1 = 1 * size // 4
    c2 = 2 * size // 4
    c3 = 3 * size // 4
  in
    case n of
    1 ->
      [ drawCircle c2 c2 10
      ]
    2 ->
      [ drawCircle c1 c1 10
      , drawCircle c3 c3 10
      ]
    3 ->
      [ drawCircle c1 c1 10
      , drawCircle c2 c2 10
      , drawCircle c3 c3 10
      ]
    4 ->
      [ drawCircle c1 c1 10
      , drawCircle c1 c3 10
      , drawCircle c3 c1 10
      , drawCircle c3 c3 10
      ]
    5 ->
      [ drawCircle c1 c1 10
      , drawCircle c1 c3 10
      , drawCircle c2 c2 10
      , drawCircle c3 c1 10
      , drawCircle c3 c3 10
      ]
    6 ->
      [ drawCircle c1 c1 10
      , drawCircle c1 c2 10
      , drawCircle c1 c3 10
      , drawCircle c3 c1 10
      , drawCircle c3 c2 10
      , drawCircle c3 c3 10
      ]
    _ ->
      [ drawCircle 0 0 0
      ]


drawDice : Die -> Html Msg
drawDice die =
  let
    size = String.fromInt die.size
  in
    svg
    [ width size
    , height size
    , viewBox ("0 0 " ++ size ++ size)
    ]
    (drawCircles die.size die.face)


view : Model -> Html Msg
view model =
  div []
  [ drawDice model
  , div [] [button [ onClick Roll ] [ Html.text "Roll" ]]
  ]