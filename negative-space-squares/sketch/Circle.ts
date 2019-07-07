class Circle {
    private readonly _r: number;
    private readonly _d: number;
    private readonly _p: Position;
    private _angle: number;

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
        p.arc(0, 0, this._d, this._d, 0, -p.PI / 2);
        p.pop();
    }

    public update(p: p5, sketch: Sketch): void {

    }
}
