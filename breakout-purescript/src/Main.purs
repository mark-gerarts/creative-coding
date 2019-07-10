module Main where

import Prelude

import Data.Int (toNumber)
import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import Effect.Console (log)
import Graphics.Canvas (rect, stroke)
import P5 (P5, draw, getP5, setup)
import P5.Color (background3)
import P5.Rendering (createCanvas)
import P5.Shape (strokeWeight)
import Web.HTML (window)
import Web.HTML.Window (innerHeight, innerWidth)

type AppState = {
  p5 :: P5
}

initialState :: Maybe AppState
initialState = Nothing

main :: Maybe AppState -> Effect (Maybe AppState)
main mAppState = do
  win <- window
  w <- toNumber <$> innerWidth win
  h <- toNumber <$> innerHeight win
  p <- maybe getP5 (\x -> pure x.p5) mAppState

  setup p do
    _ <- createCanvas p w h Nothing
    _ <- background3 p "#FF00FF" Nothing
    pure unit

  draw p do
    background3 p "#EEE" Nothing
    stroke p "#000"
    strokeWeight p 5.0
    rect p 100.0 100.0 50.0 50.0 Nothing Nothing
    rect p 110.0 110.0 50.0 50.0 Nothing Nothing
    pure unit