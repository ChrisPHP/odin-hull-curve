package hullcurve
import "core:fmt"

find_side :: proc(p1, p2, p: [2]f32) -> int {
    val := (p[1] - p1[1]) * (p2[0] - p1[0]) - (p2[1] - p1[1]) * (p[0] - p1[0])

    if val > 0 {
        return 1
    }
    if val < 0 {
        return -1
    }
    return 0
}

line_distance :: proc(p1, p2, p: [2]f32) -> f32 {
    return abs((p[1] - p1[1]) * (p2[0] - p1[0]) - (p2[1] - p1[1]) * (p[0] - p1[0]))
}

check_duplicate :: proc(np: [2]f32, hull: ^[dynamic][2]f32) -> bool {
    for p in hull {
        if p.x == np.x && p.y == np.y {
            return false
        }
    }
    return true
}

quick_hull :: proc(points: [][2]f32, hull: ^[dynamic][2]f32, n: int, p1,p2: [2]f32, side: int) {
    ind := -1
    max_dist:   f32 = 0.0

    for i:=0; i<n; i+=1 {
        temp := line_distance(p1, p2, points[i])
        if find_side(p1, p2, points[i]) == side && temp > max_dist {
            ind = i
            max_dist = temp
        }
    }

    if ind == -1 {
        if check_duplicate(p1, hull) {
            append(hull, p1)
        }
        if check_duplicate(p2, hull) {
            append(hull, p2)
        }
        return
    }

    quick_hull(points, hull, n, points[ind], p1,  -find_side(points[ind], p1, p2))
    quick_hull(points, hull, n, points[ind], p2,  -find_side(points[ind], p2, p1))
}

quickhull :: proc(points: [][2]f32, n: int) -> [][2]f32 {
    if n < 3 {
        return [][2]f32{}
    }

    convex_hull : [dynamic][2]f32

    min_x := 0
    max_x := 0

    for i:=0; i<n; i+=1 {
        if points[i][0] < points[min_x][0] {
            min_x = i
        }
        if points[i][0] > points[max_x][0] {
            max_x = i
        }
    }

    quick_hull(points, &convex_hull, n, points[min_x], points[max_x], 1)
    quick_hull(points, &convex_hull, n, points[min_x], points[max_x], -1)

    fixed_data := make([][2]f32, len(convex_hull))
    copy(fixed_data, convex_hull[:])
    delete(convex_hull)

    return fixed_data
}


jarvishull :: proc(points: [][2]f32, n: int) -> [][2]f32 {
    orientation :: proc(p, q, r: [2]f32) -> int {
        val := (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y)
        if val == 0 {
            return 0
        }
        if val > 0 {
            return 1
        }
        return 2
    }

    left_index :: proc(points: [][2]f32) -> int {
        minn := 0
        for i:=1; i<len(points); i+=1 {
            if points[i].x < points[minn].x {
                minn = i
            }
            else if  points[i].x == points[minn].x {
                if points[i].y > points[minn].y {
                    minn = i
                }
            }
        }
        return minn
    }

    if n < 3 {
        return [][2]f32{}
    }
    hull: [dynamic]int
    defer delete(hull)

    l := left_index(points)

    p := l
    q := 0
    for {

        append(&hull, p)

        q = (p+1) % n

        for i:=0; i<n; i+=1 {
            if orientation(points[p], points[i], points[q]) == 2 {
                q = i
            }
        }

        p = q

        if p == l {
            break
        }
    }
    convex_hull : [dynamic][2]f32
    for i in hull {
        append(&convex_hull, points[i])
    }

    fixed_data := make([][2]f32, len(convex_hull))
    copy(fixed_data, convex_hull[:])
    delete(convex_hull)

    return fixed_data
}
