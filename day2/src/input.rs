use std::{
    fs::File,
    io::{self, BufRead},
    path::Path,
};

pub fn read_file(path: impl AsRef<Path>) -> Vec<String> {
    let file = File::open(path).expect("Cannot open file");
    io::BufReader::new(file)
        .lines()
        .enumerate()
        .map(|(i, res)| res.unwrap_or_else(|_| panic!("Cannot parse line {}", i + 1)))
        .collect()
}
