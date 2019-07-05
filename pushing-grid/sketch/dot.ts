class Dot {

    private readonly _mass: number;
    private readonly _startPosition: Vector;
    private _position: Vector;
    private _acceleration: Vector;

    constructor(position: Vector, mass: number) {
        this._position = position;
        this._startPosition = position;
        this._mass = mass;
        this._acceleration = new Vector(0, 0);
    }

    get position(): Vector {
        return this._position;
    }

    get mass(): number {
        return this._mass;
    }

    public applyForce(force: Vector) {
        const f = Vector.div(force, this.mass);
        this._acceleration.add(f);
    }

    public update() {
        // Apply repulsor force
        // if (repulsor) {
        //     const repulseForce = repulsor.repulse(this);
        //     this.applyForce(repulseForce);
        // }

        // Add stickyness to startposition
        const stickyForce = Vector.sub(this._position, this._startPosition);
        this.applyForce(stickyForce);

        // Apply the forces.
        this._position.add(this._acceleration);
        this._acceleration = createVector(0, 0);
    }

    public draw() {
        noStroke();
        fill(settings.color.main);
        ellipse(this._position.x, this._position.y, this.mass, this.mass);
    }
}
