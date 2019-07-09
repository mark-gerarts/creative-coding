module Main where

import Prelude

import Effect (Effect, foreachE)
import Effect.Console (log)

main :: Effect Unit
main = do
  log "Hello sailor!"

testFst :: forall a. a -> String
testFst _ = "Hello world"

testSnd :: forall b. b -> Int
testSnd _ = 5
