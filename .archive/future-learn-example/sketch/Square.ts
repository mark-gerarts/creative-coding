class Square implements Shape {
    p: Pos;
    w: number;
    color: string;

    constructor(p: Pos, w: number, color: string) {
        this.p = p;
        this.w = w;
        this.color = color;
    }

    draw(): void {
        stroke(this.color);
        rect(
            this.p.x - this.w / 2,
            this.p.y - this.w / 2,
            this.w,
            this.w
        );
    }

    grow(): void {
        this.w++;
    }

    shrink(): void {
        this.w--;
    }
}
