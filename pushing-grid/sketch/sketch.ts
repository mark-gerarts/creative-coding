const settings = {
    color: {
        background: '#f5f5f5',
        main: '#15b7b9'
    },
    dot: {
        defaultSize: 20
    }
};

class Sketch {
    private _dots: Dot[] = [];

    public setup(): void {
        this.initDots();
        createCanvas(windowWidth,windowHeight);
    }

    public draw(): void {
        clear();
        background(settings.color.background);
        this._dots.forEach(dot => {
            dot.update();
            dot.draw();
        });
    }

    private initDots(): void {
        // for (let x = 150; x < 700; x += 50) {
        //     for (let y = 50; y < 600; y += 50) {
        //         const position = new Vector(x, y);
        //         grid.push(new Dot(position, DOT.DEFAULT_SIZE))
        //     }
        // }

        this._dots.push(new Dot(createVector(100, 100), settings.dot.defaultSize));
    }
}

let sketch = new Sketch();

function setup() {
    sketch.setup();
}

function draw() {
    sketch.draw();
}
