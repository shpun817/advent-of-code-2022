use crate::outcome::Outcome;

pub enum Choice {
    Rock,
    Paper,
    Scissors,
}

impl From<char> for Choice {
    fn from(c: char) -> Self {
        match c {
            'A' | 'X' => Self::Rock,
            'B' | 'Y' => Self::Paper,
            'C' | 'Z' => Self::Scissors,
            _ => panic!("Invalid char: {}", c),
        }
    }
}

impl Choice {
    pub fn from_others_choice_and_outcome(other: &Self, outcome: &Outcome) -> Self {
        match (other, outcome) {
            (Choice::Scissors, Outcome::Lose)
            | (Choice::Paper, Outcome::Draw)
            | (Choice::Rock, Outcome::Win) => Self::Paper,

            (Choice::Scissors, Outcome::Win)
            | (Choice::Paper, Outcome::Lose)
            | (Choice::Rock, Outcome::Draw) => Self::Rock,

            (Choice::Rock, Outcome::Lose)
            | (Choice::Paper, Outcome::Win)
            | (Choice::Scissors, Outcome::Draw) => Self::Scissors,
        }
    }

    /// Outcome is in the perspective of *self*
    pub fn evaluate_against(&self, other: &Self) -> Outcome {
        match (self, other) {
            (Choice::Rock, Choice::Rock)
            | (Choice::Paper, Choice::Paper)
            | (Choice::Scissors, Choice::Scissors) => Outcome::Draw,

            (Choice::Rock, Choice::Paper)
            | (Choice::Paper, Choice::Scissors)
            | (Choice::Scissors, Choice::Rock) => Outcome::Lose,

            (Choice::Rock, Choice::Scissors)
            | (Choice::Paper, Choice::Rock)
            | (Choice::Scissors, Choice::Paper) => Outcome::Win,
        }
    }

    pub fn to_score(&self) -> i32 {
        match self {
            Choice::Rock => 1,
            Choice::Paper => 2,
            Choice::Scissors => 3,
        }
    }
}
