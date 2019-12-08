///
/// --- Day 2: 1202 Program Alarm ---
/// 
/// 1) To do this, before running the program, replace position 1 with the 
/// value 12 and replace position 2 with the value 2. 
/// What value is left at position 0 after the program halts?
///
/// 2) Find the input noun and verb that cause the program to produce the
/// output 19690720. What is 100 * noun + verb?
///
/// -------------------------------------------------
///

use std::io::Read;

fn main() -> Result<(), std::io::Error> {
    // Read in puzzle input
    let mut buffer = String::new();
    std::io::stdin().read_to_string(&mut buffer)?;

    // Process input
    let input: Vec<usize> = buffer.split(',')
        .filter_map(|arg| arg.parse::<usize>().ok())
        .collect();

    // Part 1
    println!("The value left at position 0 after the program halts = {}",
             intcode(input.clone(), 12, 2));

    // Part 2
    for noun in 0..99 {
        for verb in 0..99 {
            if intcode(input.clone(), noun, verb) == 19690720 {
                println!("Noun = {}, verb = {}", noun, verb);
                println!("100 * noun + verb = {}", 100 * noun + verb);
            }
        }
    }

    // Finish
    Ok(())
}

fn intcode(mut input: Vec<usize>, noun: usize, verb: usize) -> usize {
    // 1202 replacement
    input[1] = noun;
    input[2] = verb;
    
    // Iterate over intcode program
    let mut address = 0;
    while address < input.len() {
        // Match intructions
        match input[address] {
            1 => {
                let a = input[address + 1];
                let b = input[address + 2];
                let c = input[address + 3];
                input[c] = input[a] + input[b];
                address += 4
            },
            2 => {
                let a = input[address + 1];
                let b = input[address + 2];
                let c = input[address + 3];
                input[c] = input[a] * input[b];
                address += 4
            }
            99 => break,
            _ => {
                address += 1;
            }
        }
    }

    input[0]
}
