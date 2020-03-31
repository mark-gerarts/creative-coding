module Main exposing (main)

import Browser
import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Canvas.Settings.Advanced exposing (..)
import Canvas.Settings.Text exposing (..)
import Color
import Debug exposing (..)
import Grid exposing (fold2d)
import Html exposing (Html)
import Html.Events.Extra.Mouse as Mouse
import List exposing (map)


type Msg
    = MouseMoved ( Float, Float )


type alias Model =
    { mousePosition : Maybe Point }


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


width : Float
width =
    700


height : Float
height =
    700


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


init : () -> ( Model, Cmd Msg )
init () =
    ( { mousePosition = Nothing }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update (MouseMoved p) _ =
    ( { mousePosition = Just p }, Cmd.none )


view : Model -> Html Msg
view { mousePosition } =
    Canvas.toHtml
        ( round width, round height )
        [ Mouse.onMove (.offsetPos >> MouseMoved) ]
        (clearScreen :: renderLines mousePosition)


clearScreen : Renderable
clearScreen =
    shapes [ fill Color.white ] [ rect ( 0, 0 ) width height ]


renderLines : Maybe Point -> List Renderable
renderLines mousePosition =
    let
        angle =
            case mousePosition of
                Just ( mouseX, mouseY ) ->
                    \( x, y ) -> negate <| atan2 (x - mouseX) (y - mouseY)

                Nothing ->
                    \_ -> 0

        coordinates =
            fold2d
                { rows = 40, cols = 40 }
                (\( x, y ) result -> ( (x * 15) + 50, (y * 15) + 50 ) :: result)
                []
                |> map (\( x, y ) -> ( toFloat x, toFloat y ))

        toLine ( x, y ) =
            shapes
                [ fill Color.black
                , transform [ translate x y, rotate (angle ( x, y )) ]
                ]
                [ rect ( -1, -5 ) 2 10 ]
    in
    map toLine coordinates
