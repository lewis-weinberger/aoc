///
/// --- Day 1: The Tyranny of the Rocket Equation ---
///
/// What is the sum of the fuel requirements for all of the modules on your spacecraft?
/// 
/// -------------------------------------------------
///
use std::io::Read;

fn main() -> Result<(), std::io::Error> {
    // Read in puzzle input
    let mut buffer = String::new();
    std::io::stdin().read_to_string(&mut buffer)?;

    // Process input
    let input: Vec<Option<isize>> = buffer.lines()
        .map(|arg| arg.parse::<isize>().ok())
        .collect();

    // Accumulate total fuel
    let total = input.iter().fold(0, |sum, x| {
        match x {
            Some(mass) => sum + (*mass / 3) - 2,
            None => sum,
        }
    });

    // Print result
    println!("Total required fuel = {}", total);

    // Finish
    Ok(())
}
