use crate::{choice::Choice, outcome::Outcome};

pub struct Round {
    my_choice: Choice,
    others_choice: Choice,
}

impl Round {
    pub fn from_raw_str_part1(s: &str) -> Self {
        Self {
            my_choice: Choice::from(s.chars().nth(2).unwrap()),
            others_choice: Choice::from(s.chars().next().unwrap()),
        }
    }

    pub fn from_raw_str_part2(s: &str) -> Self {
        let others_choice = Choice::from(s.chars().next().unwrap());
        let outcome = Outcome::from(s.chars().nth(2).unwrap());
        Self {
            my_choice: Choice::from_others_choice_and_outcome(&others_choice, &outcome),
            others_choice,
        }
    }

    pub fn evaluate_total_score(&self) -> i32 {
        self.my_choice.to_score()
            + self
                .my_choice
                .evaluate_against(&self.others_choice)
                .to_score()
    }
}
