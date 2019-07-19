module Vector where
  
import Prelude

type Vector = {
    x :: Number,
    y :: Number
}

add :: Vector -> Vector -> Vector
add v1 v2 = {x: v1.x + v2.x, y: v1.y + v2.y}