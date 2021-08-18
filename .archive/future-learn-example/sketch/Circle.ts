class Circle implements Shape {
    p: Pos;
    r: number;
    color: string;

    constructor(p: Pos, r: number, color: string) {
        this.p = p;
        this.r = r;
        this.color = color;
    }

    draw(): void {
        stroke(this.color);
        circle(this.p.x, this.p.y, 2 * this.r);
    }

    grow(): void {
        this.r += 0.5;
    }

    shrink(): void {
        this.r -= 0.5;
    }
}
