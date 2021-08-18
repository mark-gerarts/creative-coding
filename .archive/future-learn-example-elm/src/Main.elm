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
import List exposing (filter, map)


type alias Palette =
    { bg : Color
    , squares : Color
    , circles : Color
    , smallCircles : Color
    }


type alias Model =
    { count : Float
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
    800


height : Int
height =
    width


baseLength : Float
baseLength =
    toFloat width / 10


palette : Palette
palette =
    { bg = Color.black
    , squares = Color.darkGreen
    , circles = Color.lightPurple
    , smallCircles = Color.lightCharcoal
    }


transparent : Color
transparent =
    Color.rgba 0 0 0 0


init : () -> ( Model, Cmd Msg )
init () =
    ( { count = 0 }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update (Frame _) model =
    ( { model | count = model.count + 1 }, Cmd.none )


view : Model -> Html Msg
view { count } =
    Canvas.toHtml ( width, height ) [] (render count)


clearScreen : Renderable
clearScreen =
    shapes [ fill palette.bg ] [ rect ( 0, 0 ) (toFloat width) (toFloat height) ]


render : Float -> List Renderable
render count =
    let
        growthFactor =
            2 + sin (degrees (count / 2))
    in
    [ clearScreen
    , renderSquares growthFactor
    , renderCircles growthFactor
    , renderSmallCircles growthFactor
    ]


centerPoint : Point -> Point
centerPoint ( x, y ) =
    ( x + baseLength / 2, y + baseLength / 2 )


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
            gridCoordinates
                |> map centerPoint
                |> map (\( x, y ) -> rect ( x - w / 2, y - w / 2 ) w w)

        settings =
            [ fill transparent
            , stroke palette.squares
            , lineWidth 2
            ]
    in
    shapes settings squares


renderCircles : Float -> Renderable
renderCircles growthFactor =
    let
        r =
            (baseLength / 2) * growthFactor

        circles =
            gridCoordinates
                |> map centerPoint
                |> map (\p -> circle p r)

        settings =
            [ fill transparent
            , stroke palette.circles
            , lineWidth 2
            ]
    in
    shapes settings circles


renderSmallCircles : Float -> Renderable
renderSmallCircles growthFactor =
    let
        r =
            (baseLength / 4) * growthFactor

        movePointToBottomRight ( x, y ) =
            ( x + baseLength, y + baseLength )

        circles =
            gridCoordinates
                |> map movePointToBottomRight
                |> filter (\( x, y ) -> x < toFloat width && y < toFloat height)
                |> map (\p -> circle p r)

        settings =
            [ fill transparent
            , stroke palette.smallCircles
            , lineWidth 2
            ]
    in
    shapes settings circles
