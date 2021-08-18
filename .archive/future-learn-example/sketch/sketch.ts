enum State {
    GROWING,
    SHRINKING
}

interface DrawState {
    originalRadius: number,
    state: State,
    counter: number,
    maxCount: number,
    shapes: Shape[]
}

interface Pos {
    x: number,
    y: number
}

let state: DrawState;

function setup(): void {
    createCanvas(windowWidth, windowHeight);
    state = initState();
    initShapes(state);
    frameRate(15);
}

function draw(): void {
    background(0);
    stroke(255);
    noFill();
    strokeWeight(2);

    drawShapes(state.shapes);
    cycleShapes(state);
}

function initState(): DrawState {
    const radius = innerWidth / Math.floor(innerWidth / 50);

    return {
        originalRadius: radius,
        state: State.GROWING,
        counter: 0,
        maxCount: 150,
        shapes: []
    };
}

function initShapes(state: DrawState): DrawState {
    const diameter = state.originalRadius * 2;
    const radius = state.originalRadius;
    for (let x = 0; x < windowWidth - diameter; x += diameter) {
        for (let y = 0; y < windowHeight; y += diameter) {
            state.shapes.push(new Square({x: x + radius, y: y + radius}, diameter, '#fcf7bb'));
            state.shapes.push(new Circle({x: x + radius, y: y + radius}, radius, '#cbe2b0'));
            state.shapes.push(new Circle({x: x + diameter, y: y + diameter}, radius / 2, '#f19292'));
        }
    }

    return state;
}

function drawShapes(shapes: Shape[]): void {
    shapes.forEach(shape => {
        shape.draw();
    });
}

function cycleShapes(state: DrawState): DrawState {
    state.counter++;

    if (state.counter >= state.maxCount) {
        if (state.state == State.GROWING) {
            state.state = State.SHRINKING;
        }
        else {
            state.state = State.GROWING;
        }

        state.counter = 0;
    }

    state.shapes.forEach(shape => {
        if (state.state == State.GROWING) {
            shape.grow();
        }
        else {
            shape.shrink();
        }
    });

    return state;
}
