module Breakout where

import Prelude

import Control.Monad.State (StateT, execStateT, get, lift, put)
import Data.Int (toNumber)
import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import P5 (P5, draw, getP5, setup)
import P5.Color (background3, clear, fill, noStroke)
import P5.Rendering (createCanvas)
import P5.Shape (ellipse)
import Vector (Vector, dot)
import Web.HTML (window)
import Web.HTML.Window (innerHeight, innerWidth)

type AppState = {
  p5 :: P5
}

type GameState = {
  gameWidth :: Number,
  gameHeight :: Number,
  ball :: Ball
}

type Position = Vector

data Ball = Ball {
  p :: Position,
  r :: Number,
  a :: Vector
}

constrain :: forall a. Ord a => a -> a -> a -> a
constrain x min max
    | x < min = min
    | x > max = max
    | otherwise = x

isOutOfBounds :: forall a. Ord a => a -> a -> a -> Boolean
isOutOfBounds x min max = x <= min || x >= max

initialState :: Maybe AppState
initialState = Nothing

drawBall :: P5 -> Ball -> Effect Unit
drawBall p (Ball ball) = do
  noStroke p
  fill p ("#0093e0")
  ellipse p ball.p.x ball.p.y ball.r (Just ball.r)

updateBall :: Ball -> Number -> Number -> Ball
updateBall (Ball ball) w h =
  let
    updatedPosition = add ball.p ball. a
    constrainedPosition = {
      x: constrain updatedPosition.x 0.0 w,
      y: constrain updatedPosition.y 0.0 h
    }
    bounce = {
      x: if isOutOfBounds updatedPosition.x 0.0 w then -1.0 else 1.0,
      y: if isOutOfBounds updatedPosition.y 0.0 h then -1.0 else 1.0
    }
  in
    Ball ball { p = constrainedPosition, a = dot bounce ball.a }

updateStep :: P5 -> StateT GameState Effect Unit
updateStep p = do
  state <- get
  let ball = state.ball
      newBall = updateBall state.ball state.gameWidth state.gameHeight
  put $ state { ball = newBall }
  pure unit

drawStep :: P5 -> GameState -> Effect Unit
drawStep p state = do
  clear p
  background3 p "#eeeeee" Nothing
  drawBall p (state.ball)

drawSketch :: P5 -> StateT GameState Effect Unit
drawSketch p = do
  state <- get
  updateStep p
  lift $ drawStep p state

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
    centerX = w / 2.0
    centerY = h / 2.0
    center = { x: centerX, y: centerY }
    initialBall = Ball { p: center, r: 20.0, a: { x: 5.0, y: 5.0 } }
    initialGameState = { gameWidth: w, gameHeight: h, ball: initialBall }

  setup p do
    _ <- createCanvas p w h Nothing
    pure unit

  draw p (statefulDraw p initialGameState)

  pure $ Just { p5: p }