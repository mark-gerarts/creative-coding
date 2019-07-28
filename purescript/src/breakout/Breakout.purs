module Breakout where

import Prelude

import Control.Monad.State (StateT, execStateT, get, lift)
import Data.Int (toNumber)
import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import P5 (P5, draw, getP5, setup)
import P5.Color (background3, clear, fill, noStroke)
import P5.Rendering (createCanvas)
import P5.Shape (ellipse)
import Vector (Vector)
import Web.HTML (window)
import Web.HTML.Window (innerHeight, innerWidth)

type AppState = {
  p5 :: P5
}

type GameState = {
  ball :: Ball
}

type Position = Vector

data Ball = Ball {
  p :: Position,
  r :: Number,
  a :: Vector
}

initialState :: Maybe AppState
initialState = Nothing

drawBall :: P5 -> Ball -> Effect Unit
drawBall p (Ball ball) = do
  noStroke p
  fill p ("#0093e0")
  ellipse p ball.p.x ball.p.y ball.r (Just ball.r)

drawStep :: P5 -> StateT GameState Effect Unit
drawStep p = do
  state <- get

  lift $ clear p
  lift $ background3 p "#eeeeee" Nothing
  lift $ drawBall p (state.ball)

drawSketch :: P5 -> StateT GameState Effect Unit
drawSketch p = do
  drawStep p
  pure unit

statefulDraw :: P5 -> GameState -> Effect Unit
statefulDraw p state = do
  s <- execStateT (drawSketch p) state
  draw p (statefulDraw p s)

main :: Maybe AppState -> Effect (Maybe AppState)
main mAppState = do
  win <- window
  w <- toNumber <$> innerWidth win
  h <- toNumber <$> innerHeight win
  p <- maybe getP5 (\x -> pure x.p5) mAppState

  let
    initialBall = Ball { p: {x: w / 2.0, y: h / 2.0}, r: 20.0, a: { x: 2.0, y: 2.0 } }
    initialGameState = { ball: initialBall }

  setup p do
    _ <- createCanvas p w h Nothing
    pure unit

  draw p (statefulDraw p initialGameState)

  pure $ Just { p5: p }