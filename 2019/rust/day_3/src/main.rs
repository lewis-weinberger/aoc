///
/// --- Day 3: Crossed Wires ---
///
/// 1) What is the Manhattan distance from the central port to
/// the closest intersection?
///
/// 2) What is the fewest combined steps the wires must take to
/// reach an intersection?
///
/// -------------------------------------------------
///

use std::io::Read;

fn main() -> Result<(), std::io::Error> {
    // Read in puzzle input
    let mut buffer = String::new();
    std::io::stdin().read_to_string(&mut buffer)?;

    // Process input
    let mut paths: [Vec<(isize, isize)>; 2] = [vec![(0, 0)], vec![(0, 0)]];
    for (path, line) in paths.iter_mut().zip(buffer.lines()) {
        for (i, step) in line.split(',').enumerate() {
            if let Some(node) = routing(step, path[i]) {
                path.push(node)
            };
        }
    }

    // Determine all intersections between paths
    let crossings = intersections(&paths);
   
    // Part 1
    if let Some(distance) = min_distance(&crossings) {
        println!(
            "Part 1) The closest intersection is {} away from the central port",
            distance
        );
    }

    // Part 2
    if let Some(distance) = min_steps(&paths, &crossings) {
        println!(
            "Part 2) {} combined steps to reach nearest intersection",
            distance
        );
    }

    // Finish
    Ok(())
}

// Process step to find next node in wire path
fn routing(step: &str, last: (isize, isize)) -> Option<(isize, isize)> {
    let (dir, distr) = step.split_at(1);
    let dist = match distr.parse::<isize>() {
        Ok(d) => d,
        Err(_) => {
            eprintln!("Unable to process step {}!", step);
            return None;
        }
    };
    match dir {
        "U" => Some((last.0, last.1 + dist)),
        "D" => Some((last.0, last.1 - dist)),
        "L" => Some((last.0 - dist, last.1)),
        "R" => Some((last.0 + dist, last.1)),
        _ => None,
    }
}

// Find intersections by pairwise search over line segments in wire paths
fn intersections(paths: &[Vec<(isize, isize)>; 2]) -> Vec<(isize, isize)> {
    let mut crossings: Vec<(isize, isize)> = Vec::new();

    // Loop over line segments
    let mut pc = 0;
    for (x2, y2) in paths[0].iter().skip(1) {
        let (x1, y1) = paths[0][pc];
        pc += 1;
        
        let mut qc = 0;
        for (x4, y4) in paths[1].iter().skip(1) {
            let (x3, y3) = paths[1][qc];
            qc += 1;

            // Bezier parameterization
            let dx12 = (x1 - x2) as f64;
            let dx13 = (x1 - x3) as f64;
            let dx34 = (x3 - x4) as f64;
            let dy12 = (y1 - y2) as f64;
            let dy13 = (y1 - y3) as f64;
            let dy34 = (y3 - y4) as f64;
            let denom = dx12 * dy34 - dy12 * dx34;

            if denom != 0.0 {
                // Perpendicular intersections
                let t = (dx13 * dy34 - dy13 * dx34) / denom;
                if t >= 0.0 && t <= 1.0 {
                    let u = -(dx12 * dy13 - dy12 * dx13) / denom;
                    if u >= 0.0 && u <= 1.0 {
                        crossings.push((x1 - (t*dx12) as isize,
                                        y1 - (t*dy12) as isize));
                    }
                }
            } else if dx12 == 0.0 && dx34 == 0.0 {
                // TO-DO: Horizontal coincident intersections
                
            } else if dy12 == 0.0 && dy34 == 0.0 {
                // TO-DO: Vertical coincident intersections
                
            }
        }
    }
    crossings
}

// Find closest intersection by manhattan distance
fn min_distance(crossings: &[(isize, isize)]) -> Option<isize> {
    crossings.iter()
        .map(|(x, y)| x.abs() + y.abs()) // manhattan distance
        .min()
}

// Find closest intersection by total number of steps
fn min_steps(paths: &[Vec<(isize, isize)>; 2], crossings: &[(isize, isize)]) -> Option<isize> {
    // Determine points along paths
    let mut steps: Vec<isize> = vec![0; crossings.len()];
    for path in paths.iter() {
        let mut current: (isize, isize) = (0, 0);
        let mut step_count = 0;
        for node in path.iter() {
            let mut dx = node.0 - current.0;
            let mut dy = node.1 - current.1;
            while dx != 0 || dy != 0 {
                // For each point in path, compare against all known intersections
                for (step, &crossing) in steps.iter_mut().zip(crossings.iter()) {
                    if current == crossing {
                        *step += step_count;
                    }
                }

                // Move on to next point in wire path
                current.0 += dx.signum();
                current.1 += dy.signum();
                dx -= dx.signum();
                dy -= dy.signum();
                step_count += 1;
            }
        }
    }
    steps.into_iter().min()
}
