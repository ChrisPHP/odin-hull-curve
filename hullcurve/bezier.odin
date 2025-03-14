package hullcurve

import "core:fmt"

two_points :: proc(t: f32, p1, p2: [2]f32) -> [2]f32 {
    q1 := (1 - t) * p1 + t * p2
    return q1
}

bezier_points :: proc(t: f32, points: [][2]f32) -> [][2]f32 {
    new_points: [dynamic][2]f32
    for i:=0; i<len(points)-1; i+=1 {
        append(&new_points, two_points(t, points[i], points[i+1]))
    }

    fixed_data := make([][2]f32, len(new_points))
    copy(fixed_data, new_points[:])
    delete(new_points)

    return fixed_data
}

bezier_point :: proc(t: f32, points: [][2]f32) -> [2]f32 {
    new_points := make([][2]f32, len(points))
    copy(new_points, points[:])

    for len(new_points) > 1 {
        newer_array := bezier_points(t,new_points)

        delete(new_points)
        new_points = make([][2]f32, len(newer_array))
        copy(new_points, newer_array[:])
        delete(newer_array)
    }
    
    fixed_data := make([][2]f32, len(new_points))
    copy(fixed_data, new_points[:])
    delete(new_points)

    point := fixed_data[0]
    delete(fixed_data)
    return point
}

bezier_curve :: proc(points: [][2]f32, steps: f32) -> [][2]f32 {
    curve_points: [dynamic][2]f32


    for i:f32=0.0;i<steps; i+=1 {
        t :f32= i / steps

        append(&curve_points, bezier_point(t, points))
    }
    append(&curve_points, points[len(points)-1])

    fixed_data := make([][2]f32, len(curve_points))
    copy(fixed_data, curve_points[:])
    delete(curve_points)

    return fixed_data
}
