const settings = {
    color: {
        background: '#f5f5f5',
        main: '#15b7b9'
    },
    dot: {
        defaultSize: 20
    },
    repulsor: {
        defaultSize: 50,
        G: 20
    }
};

let dots: Dot[];
let repulsor: Repulsor;

function setup(): void {
    dots = initDots();
    repulsor = new Repulsor(
        new Vector(-100, -100),
        settings.repulsor.G,
        settings.repulsor.defaultSize
    );
    createCanvas(windowWidth, windowHeight);
}

function update(): void {
    repulsor.update();
    dots.forEach(dot => dot.update(repulsor));
}

function draw(): void {
    update();
    clear();
    background(settings.color.background);
    dots.forEach(dot => dot.draw());
}

function mouseMoved() {
    repulsor.position = new Vector(mouseX, mouseY);
}

function mouseDragged() {
    mouseMoved();
}

function mouseReleased() {
    repulsor.shrink();
}

function initDots(): Dot[] {
    const margin = 50;
    let dots = [];

    for (let x = margin; x <= windowWidth - margin; x += margin) {
        for (let y = margin; y <= windowHeight - margin; y += margin) {
            const position = new Vector(x, y);
            const dot = new Dot(position, settings.dot.defaultSize);
            dots.push(dot);
        }
    }

    return dots;
}

window.onresize = () => {
    setup();
};
