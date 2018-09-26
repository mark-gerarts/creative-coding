const COLOR = {
    BACKGROUND: '#f5f5f5',
    MAIN: '#15b7b9'
};
const DOT = {
    DEFAULT_SIZE: 20
};

let dots;
let repulsor;

class Vector {
    constructor(x, y) {
        this.x = x;
        this.y = y;
    }

    static sub(v1, v2) {
        return new Vector(v1.x - v2.x, v1.y - v2.y);
    }

    static add(v1, v2) {
        return new Vector(v1.x + v2.x, v1.y + v2.y);
    }

    static div(force, n) {
        return new Vector(force.x / n, force.y / n);
    }

    static mult(force, n) {
        return new Vector(force.x * n, force.y * n);
    }

    div(n) {
        this.x /= n;
        this.y /= n;
    }

    mult(n) {
        this.x *= n;
        this.y *= n;
    }

    add(force) {
        this.x += force.x;
        this.y += force.y;
    }

    mag() {
        return Math.sqrt(this.x * this.x + this.y * this.y);
    }

    normalize() {
        this.div(this.mag());
    }
}

class Dot {
    constructor(position, mass) {
        this.position = position;
        this.mass = mass;
        this.acceleration = new Vector(0, 0);
    }

    applyForce(force) {
        f = Vector.div(force, this.mass);
        acceleration.add(f);
    }

    draw() {
        noStroke();
        fill(COLOR.MAIN);
        ellipse(this.position.x, this.position.y, this.mass, this.mass);
    }
}

class Repulsor {
    constructor(position, G, mass = 20) {
        this.position = position;
        this.G = G;
        this.mass = mass;
    }

    repulse(dot) {
        let force = Vector.sub(dot.position, this.position);
        const distance = constrain(force.mag(), 5, 25);
        force.normalize();
        const strength = (this.G * dot.mass * this.mass) / (distance * distance);
        force.mult(strength);

        return force;
    }
}

function constrain(x, min, max) {
    if (x > max) {
        return max;
    }
    if (x < min) {
        return min;
    }

    return x;
}

function initGrid() {
    let grid = [];
    for (let x = 150; x < 700; x += 50) {
        for (let y = 50; y < 600; y += 50) {
            const position = new Vector(x, y);
            grid.push(new Dot(position, DOT.DEFAULT_SIZE))
        }
    }

    return grid;
}

function setup() {
    createCanvas(800, 600);
    background(COLOR.BACKGROUND);
    dots = initGrid();
    repulsor = new Repulsor(new Vector(400, 300), 20);
}

function draw() {
    dots.forEach(dot => {
        repulsor.repulse(dot);
        dot.draw();
    });
}
