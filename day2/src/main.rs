use aoc2022_day2::{input::read_file, round::Round};

fn main() {
    // let input_lines = read_file("dummy_input.txt");
    let input_lines = read_file("input.txt");

    let strategy_total_score_part1: i32 = input_lines
        .iter()
        .map(|line| Round::from_raw_str_part1(line).evaluate_total_score())
        .sum();
    println!("Part 1: {}", strategy_total_score_part1);

    let strategy_total_score_part2: i32 = input_lines
        .into_iter()
        .map(|line| Round::from_raw_str_part2(&line).evaluate_total_score())
        .sum();
    println!("Part 2: {}", strategy_total_score_part2);
}
