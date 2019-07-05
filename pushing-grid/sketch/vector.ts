/**
 * Extends the p5 vector and adds a constructor for it. Otherwise the only way
 * to create vectors would be using `createVector(...)`.
 */
class Vector extends p5.Vector {
    constructor (x: number, y: number, z?: number) {
        super();
        this.x = x;
        this.y = y;
        this.z = z;
    }
}
