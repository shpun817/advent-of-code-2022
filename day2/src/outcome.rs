pub enum Outcome {
    Win,
    Draw,
    Lose,
}

impl From<char> for Outcome {
    fn from(c: char) -> Self {
        match c {
            'X' => Self::Lose,
            'Y' => Self::Draw,
            'Z' => Self::Win,
            _ => panic!("Invalid char: {}", c),
        }
    }
}

impl Outcome {
    pub fn to_score(&self) -> i32 {
        match self {
            Outcome::Win => 6,
            Outcome::Draw => 3,
            Outcome::Lose => 0,
        }
    }
}
