# Creative coding

Some creative coding miniprojects.

- [Pushing grid](https://github.com/mark-gerarts/creative-coding/tree/master/pushing-grid)

The p5.js projects are based on the [p5 typescript starter](https://github.com/Gaweph/p5-typescript-starter).

## Creating a new TS+P5 sketch

```
$ ./create-sketch my-new-sketch
```

## Building optimized elm sketches

```
$ elm make src/Main.elm --optimize --output=sketch.js
$ uglifyjs sketch.js --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" | uglifyjs --mangle --output=sketch.min.js
```
