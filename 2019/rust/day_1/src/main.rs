///
/// --- Day 1: The Tyranny of the Rocket Equation ---
///
/// Part 1) What is the sum of the fuel requirements for all of the
/// modules on your spacecraft?
///
/// Part 2) What is the sum of the fuel requirements for all of the
/// modules on your spacecraft when also taking into account the mass
/// of the added fuel?
/// 
/// -------------------------------------------------
///
use std::io::Read;

fn main() -> Result<(), std::io::Error> {
    // Read in puzzle input
    let mut buffer = String::new();
    std::io::stdin().read_to_string(&mut buffer)?;

    // Process input
    let input: Vec<isize> = buffer.lines()
        .filter_map(|arg| arg.parse::<isize>().ok())
        .collect();

    // Part 1) Accumulate total fuel
    let mut total = input.iter().fold(0, |sum, x| sum + (x / 3) - 2);
    println!("Part 1) Total required fuel = {}", total);

    // Part 2) Accumulate total fuel including mass of added fuel
    total = input.iter().fold(0, |sum, x| sum + fuel(0, *x));
    println!("Part 2) Total required fuel = {}", total);

    // Finish
    Ok(())
}

fn fuel(total: isize, remaining: isize) -> isize {
    // Calculate required fuel for remaining mass
    let input = (remaining / 3) - 2;

    // Check if any more fuel needs to be accounted for
    if input <= 0 {
        total
    } else {
        fuel(total + input, input)
    }
}
