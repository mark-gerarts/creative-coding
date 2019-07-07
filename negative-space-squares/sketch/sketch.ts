const settings = {
    circleRadius: 75,
    circleColor: '#000',
    backgroundColor: '#FFF'
};

enum Direction {
    UP,
    RIGHT,
    DOWN,
    LEFT
}

class Sketch {
    private readonly _circles: Circle[] = [];

    public setup(p: p5): void {
        p.createCanvas(p.windowWidth, p.windowHeight);
        p.background(settings.backgroundColor);
        this.initCircles(p);
    }

    public update(p: p5): void {
        this._circles.forEach((c) => {
            c.update(p, this);
        });
    }

    public draw(p: p5): void {
        this._circles.forEach((c) => {
            c.draw(p);
        });
    }

    private initCircles(p: p5): void {
        const r = settings.circleRadius;
        const d = r + r;
        for (let x = r; x <= p.windowWidth - r; x += d) {
            for (let y = r; y <= p.windowHeight - r; y += d) {
                let yi = Math.floor(y / d);
                let xi = Math.floor(x / d);
                let verticalDirection = yi  % 2 == 0 ? Direction.UP : Direction.DOWN;
                let horizontalDirection = xi % 2 == 0 ? Direction.LEFT : Direction.RIGHT;
                let angle = this.getAngleFromDirections(verticalDirection, horizontalDirection, p);
                this._circles.push(new Circle(r, new Position(x, y), angle));
            }
        }
    }

    private getAngleFromDirections(
        verticalDirection: Direction,
        horizontalDirection: Direction,
        p : p5
    ): number {
        const PI = p.PI;
        if (verticalDirection == Direction.UP) {
            return horizontalDirection == Direction.RIGHT ? -PI / 2 : -PI;
        }

        return horizontalDirection == Direction.RIGHT ? 0 : PI / 2;
    }
}

let sketch = new Sketch();
let p = (p: p5) => {
    p.setup = () => {
        sketch.setup(p);
    };

    p.draw = () => {
        sketch.update(p);
        sketch.draw(p);
    };
};

new p5(p);
