package main

import rl "vendor:raylib"
import hull "hullcurve"
import "core:math/rand"


main :: proc() {
    rl.InitWindow(1000, 1000, "Convex Hull")
    rl.SetTargetFPS(60)

    a := make([][2]f32, 10)
    defer delete(a)

    for &p in a {
        x := rand.float32_range(0, 1000)
        y := rand.float32_range(0, 1000)
        p = [2]f32{x, y}
    }
    
    hull_points := hull.jarvishull(a, len(a))
    curve_points := hull.bezier_curve(hull_points, 0)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        for i:=0; i<len(curve_points)-1; i+=1 {
            rl.DrawLineEx(curve_points[i], curve_points[i+1], 32, rl.WHITE)
            rl.DrawCircleV(curve_points[i], 32, rl.RED)
            rl.DrawCircleV(curve_points[i+1], 32, rl.RED)
        }

        rl.EndDrawing()
    }
    rl.CloseWindow()
}