class Repulsor {
    private readonly G: number;
    private readonly mass: number;
    private position: Vector;

    constructor(position: Vector, G: number, mass = 20) {
        this.position = position;
        this.G = G;
        this.mass = mass;
    }

    public repulse(dot: Dot): Vector {
        let force = Vector.sub(dot.position, this.position);
        const distance = constrain(force.mag(), 5, 25);
        force.normalize();
        const strength = (this.G * dot.mass * this.mass) / (distance * distance);
        force.mult(strength);

        return force;
    }

    public update(): void {
        this.position = createVector(mouseX, mouseY);
    }
}
