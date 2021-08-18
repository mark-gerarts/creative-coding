class Repulsor {
    private readonly _G: number;
    private _mass: number;
    private _position: Vector;

    constructor(position: Vector, G: number, mass = 20) {
        this._position = position;
        this._G = G;
        this._mass = mass;
    }

    public repulse(dot: Dot): Vector {
        const maxDistance = 150;
        let force = Vector.sub(dot.position, this._position);
        const distance = constrain(force.mag(), 0, maxDistance);
        // Don't apply any force if the repulsor is sufficiently far away.
        if (distance >= maxDistance) {
            return new Vector(0, 0);
        }
        force.normalize();
        const strength = (this._G * dot.mass * this._mass) / (distance * distance);
        force.mult(strength);

        return force;
    }

    public update(): void {
        if (mouseIsPressed) {
            this.grow();
        }
    }

    public grow(): void {
        this._mass += 10;
    }

    public shrink(): void {
        this._mass = settings.repulsor.defaultSize;
    }

    set position(value: Vector) {
        this._position = value;
    }
}
