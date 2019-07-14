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
import Vector (Vector)
import Web.HTML (window)
import Web.HTML.Window (innerWidth, innerHeight)

type AppState = {
  p5 :: P5,
  ball :: Ball
  {- paddle :: Paddle,
  bricks :: List Brick -}
}

data Color = Primary | Secondary

type Position = Vector

newtype Brick = Brick {
  position :: Position,
  width :: Number,
  height :: Number,
  color :: Color
}

newtype Paddle = Paddle {
  position :: Position,
  width :: Number,
  height :: Number,
  color :: Color
}

newtype Ball = Ball {
  position :: Position,
  radius :: Number,
  color :: Color
}

class Draw a where
  drawObject :: P5 -> a -> Effect Unit

instance drawBrick :: Draw Brick where
  drawObject p brick = do
    noStroke
    fill (getHex brick.color)
    rect p brick.position.x brick.position.y brick.width brick.height

instance drawPaddle :: Draw Paddle where
  drawObject p paddle = do
    noStroke
    fill (getHex paddle.color)
    rect p paddle.position.x paddle.position.y paddle.width paddle.weight 

instance drawBall :: Draw Ball where
  drawObject p ball = do
    noStroke
    (fill . getHex) ball.color
    ellipse ball.position.x ball.position.y ball.radius ball.radius

getHex :: Color -> String
getHex c = case c of
  Primary -> "#0093e0"
  Secondary -> "#eeeeee"

initialState :: Maybe AppState
initialState = Just {
  p5: getP5,
  ball: Ball { position: {x: 10.0, y: 10.0}, radius: 5.0, color: Primary}
}

main :: Maybe AppState -> Effect (Maybe AppState)
main mAppState = do
  win <- window
  w <- toNumber <$> innerWidth win
  h <- toNumber <$> innerHeight win
  p <- maybe getP5 (\x -> pure x.p5) mAppState

  setup p do
    _ <- createCanvas p w h Nothing
    background3 p (getHex Secondary) Nothing
    pure unit

  draw p do
    pure unit

  pure $ Just { p5: p, ball: mAppState.ball }
