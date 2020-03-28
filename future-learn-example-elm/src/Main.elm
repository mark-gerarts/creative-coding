module Main exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Canvas.Settings.Advanced exposing (..)
import Canvas.Settings.Line exposing (..)
import Canvas.Settings.Text exposing (..)
import Color exposing (Color)
import Grid exposing (fold2d)
import Html exposing (Html)
import List exposing (map)


type State
    = Growing
    | Shrinking


type alias Model =
    { count : Float
    , state : State
    }


type Msg
    = Frame Float


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> onAnimationFrameDelta Frame
        }


width : Int
width =
    500


height : Int
height =
    500


baseLength : Float
baseLength =
    50


bg : Color
bg =
    Color.black


init : () -> ( Model, Cmd Msg )
init () =
    ( { count = 0, state = Growing }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update (Frame _) model =
    ( { model | count = model.count + 1 }, Cmd.none )


view : Model -> Html Msg
view { count } =
    Canvas.toHtml ( width, height ) [] (render count)


clearScreen : Renderable
clearScreen =
    shapes [ fill bg ] [ rect ( 0, 0 ) (toFloat width) (toFloat height) ]


render : Float -> List Renderable
render count =
    let
        growthFactor =
            sin (degrees count)
    in
    [ clearScreen, renderSquares growthFactor, renderCircles, renderSmallCircles ]


gridCoordinates : List ( Float, Float )
gridCoordinates =
    let
        coordinates =
            fold2d
                { rows = 10, cols = 10 }
                (\( x, y ) result -> ( x * round baseLength, y * round baseLength ) :: result)
                []
    in
    map (\( x, y ) -> ( toFloat x, toFloat y )) coordinates


renderSquares : Float -> Renderable
renderSquares growthFactor =
    let
        w =
            baseLength * growthFactor

        squares =
            map (\p -> rect p w w) gridCoordinates

        settings =
            [ fill (Color.rgba 0 0 0 0), stroke Color.white, lineWidth 2 ]
    in
    shapes settings squares


renderCircles : Renderable
renderCircles =
    let
        movePointToCenter ( x, y ) =
            ( x + (baseLength / 2), y + (baseLength / 2) )

        circles =
            gridCoordinates
                |> map movePointToCenter
                |> map (\p -> circle p (baseLength / 2))

        settings =
            [ fill (Color.rgba 0 0 0 0), stroke Color.white, lineWidth 2 ]
    in
    shapes settings circles


renderSmallCircles : Renderable
renderSmallCircles =
    let
        movePointToBottomRight ( x, y ) =
            ( x + baseLength, y + baseLength )

        circles =
            gridCoordinates
                |> map movePointToBottomRight
                |> map (\p -> circle p (baseLength / 4))

        settings =
            [ fill (Color.rgba 0 0 0 0), stroke Color.white, lineWidth 2 ]
    in
    shapes settings circles
