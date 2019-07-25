module Breakout where

import Prelude

import Control.Monad.State (StateT, execStateT, get, lift, put)
import Data.Int (toNumber)
import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import Effect.Console (log)
import Node.Crypto.Hmac (update)
import P5 (P5, draw, getP5, setup)
import P5.Color (clear, fill, noStroke)
import P5.Rendering (createCanvas)
import P5.Shape (ellipse, rect)
import Vector (Vector, add, dot)
import Web.HTML (window)
import Web.HTML.Window (innerWidth, innerHeight)

type AppState = {
  p5 :: P5
}

type DrawState = {
  width :: Number, -- Better move width/height to a reader
  height :: Number,
  ball :: Ball
}

data Color = Primary | Secondary

type Position = Vector

data Brick = Brick {
  position :: Position,
  width :: Number,
  height :: Number,
  color :: Color
}

data Paddle = Paddle {
  position :: Position,
  width :: Number,
  height :: Number,
  color :: Color
}

data Ball = Ball {
  position :: Position,
  radius :: Number,
  color :: Color,
  a :: Vector
}

instance showBall :: Show Ball where
  show (Ball ball) = "Position: " <> show ball.position <> ", a: " <> show ball.a

class Draw a where
  drawObject :: P5 -> a -> Effect Unit

instance drawBrick :: Draw Brick where
  drawObject p (Brick brick) = do
    noStroke p
    fill p (getHex brick.color)
    rect p brick.position.x brick.position.y brick.width brick.height Nothing Nothing

instance drawPaddle :: Draw Paddle where
  drawObject p (Paddle paddle) = do
    noStroke p
    fill p (getHex paddle.color)
    rect p paddle.position.x paddle.position.y paddle.width paddle.height Nothing Nothing

instance drawBall :: Draw Ball where
  drawObject p (Ball ball) = do
    noStroke p
    fill p (getHex ball.color)
    ellipse p ball.position.x ball.position.y ball.radius (Just ball.radius)

getHex :: Color -> String
getHex c = case c of
  Primary -> "#0093e0"
  Secondary -> "#eeeeee"

initialState :: Maybe AppState
initialState = Nothing

initialDrawState :: Number -> Number -> DrawState
initialDrawState gameWidth gameHeight = { 
  width: gameWidth,
  height: gameHeight,
  ball: initialBall gameWidth gameHeight 
}

initialBall :: Number -> Number -> Ball
initialBall gameWidth gameHeight = Ball { 
  position: {x: gameWidth / 2.0, y: gameHeight - 150.0 }, 
  radius: 20.0, 
  color: Primary,
  a: { x: 2.0, y: 2.0 }
}

initialPaddle :: Number -> Number -> Paddle
initialPaddle gameWidth gameHeight = Paddle {
  position: {x: gameWidth / 2.0, y: gameHeight - 100.0},
  width: 100.0,
  height: 20.0,
  color: Primary
}

updateState :: DrawState -> DrawState
updateState s = 
  -- let ball = updateBall s.width s.height s.ball
  s

updateBall :: Ball -> Number -> Number -> Ball
updateBall ball w h = 
  let newPosition = add ball.position ball.a
      xOutOfBounds = newPosition.x - radius <= 0 || newPosition.x + radius >= w
      yOutOfBounds = newPosition.y - radius <= 0 || newPosition.y + radius >= h
      a = { x: if xOutOfBounds then -1 else 1, y: if yOutOfBounds then -1 else 0}
      
      { position: (add ball.position ball.a), a: (dot a ball.a) }

drawStep :: P5 -> StateT DrawState Effect Unit
drawStep p = do
  state <- get
  let {ball} = state
  put $ updateState state

  lift $ clear p
  lift $ drawObject p ball

drawSketch :: P5 -> StateT DrawState Effect Unit
drawSketch p = do
  drawStep p
  pure unit

statefulDraw :: P5 -> DrawState -> Effect Unit
statefulDraw p state = do
  s <- execStateT (drawSketch p) state
  draw p (statefulDraw p s)

-- @todo: figure out how to update state :(
main :: Maybe AppState -> Effect (Maybe AppState)
main mAppState = do
  win <- window
  w <- toNumber <$> innerWidth win
  h <- toNumber <$> innerHeight win
  p <- maybe getP5 (\x -> pure x.p5) mAppState

  let drawState = initialDrawState w h

  setup p do
    _ <- createCanvas p w h Nothing
    pure unit

  draw p (statefulDraw p drawState)

  pure $ Just { p5: p }
