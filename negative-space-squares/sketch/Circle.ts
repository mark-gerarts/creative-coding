class Circle {
    private readonly _r: number;
    private readonly _d: number;
    private readonly _p: Position;
    private _angle: number;
    private _targetAngle: number;
    private _remainingAngle: number;
    private _rotationDirection: RotationDirection;

    /**
     * @param r Radius
     * @param p Position
     * @param angle
     *   The angle of the circle; this is the angle of the first line of the
     *   cutout.
     */
    constructor(r: number, p: Position, angle = 10) {
        this._r = r;
        this._d = r + r;
        this._p = p;
        this._angle = angle;
    }

    public draw(p: p5): void {
        p.push();
        p.fill(settings.circleColor);
        p.translate(this._p.x, this._p.y);
        p.rotate(this._angle);
        p.arc(0, 0, this._d, this._d, p.PI / 2, 0);
        p.pop();
    }

    public update(p: p5, sketch: Sketch): void {
        if (this._remainingAngle == 0) {
            return;
        }

        let delta = p.PI / 360;
        if (this._rotationDirection == RotationDirection.COUNTERCLOCKWISE) {
            delta *= -1;
        }

        this._remainingAngle -= Math.abs(delta);
        this._angle += delta;
        if (this._remainingAngle <= delta) {
            this._angle = this._targetAngle;
            this._remainingAngle = 0;
        }
    }

    public rotate(direction: RotationDirection, angle = Math.PI * 2) {
        this._rotationDirection = direction;
        this._targetAngle = (this._angle + angle) / (2 * Math.PI);
        this._remainingAngle = Math.abs(angle);
    }
}
