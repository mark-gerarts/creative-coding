module Breakout where

import Prelude

import Data.Int (toNumber)
import Data.List.Lazy (List(..))
import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import Effect.Console (log)
import Foreign.NullOrUndefined (undefined)
import P5 (P5, draw, getP5, setup)
import P5.Color (background3, fill, noStroke, stroke)
import P5.Rendering (createCanvas)
import P5.Shape (ellipse, rect, strokeWeight)
import Vector (Vector, add)
import Web.HTML (window)
import Web.HTML.HTMLObjectElement (height)
import Web.HTML.HTMLProgressElement (position)
import Web.HTML.Window (innerWidth, innerHeight)

type AppState = {
  p5 :: P5,
  ball :: Ball,
  paddle :: Paddle
  -- bricks :: List Brick
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

initialBall :: Number -> Number -> Ball
initialBall gameWidth gameHeight = Ball { 
  position: {x: gameWidth / 2.0, y: gameHeight - 150.0 }, 
  radius: 20.0, 
  color: Primary,
  a: { x: 20.0, y: 20.0 }
}

initialPaddle :: Number -> Number -> Paddle
initialPaddle gameWidth gameHeight = Paddle {
  position: {x: gameWidth / 2.0, y: gameHeight - 100.0},
  width: 100.0,
  height: 20.0,
  color: Primary
}

-- @todo: merge this in an updateAppState or something.
updateBall :: Ball -> Ball
updateBall (Ball ball) = Ball (ball { position = add ball.position ball.a})

-- @todo: figure out how to update state :(
main :: Maybe AppState -> Effect (Maybe AppState)
main mAppState = do
  win <- window
  w <- toNumber <$> innerWidth win
  h <- toNumber <$> innerHeight win
  p <- maybe getP5 (\x -> pure x.p5) mAppState
  ball <- maybe (pure $ initialBall w h) (\x -> pure x.ball) mAppState
  paddle <- maybe (pure $ initialPaddle w h) (\x -> pure x.paddle) mAppState

  setup p do
    _ <- createCanvas p w h Nothing
    log "Setting up"
    pure unit

  draw p do
    background3 p (getHex Secondary) Nothing
    drawObject p ball
    drawObject p paddle
    log "Drawing"
    pure unit

  pure $ Just { p5: p, ball: ball, paddle: paddle}
