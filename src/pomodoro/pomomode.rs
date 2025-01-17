use std::time::Duration;
use super::PomoConfig;

#[derive(Clone, Copy, Debug)]
pub enum PomodoroMode {
    Work,
    Break,
    LongBreak,
}

impl Default for PomodoroMode {
    fn default() -> Self {
        Self::Work
    }
}

impl PomodoroMode {
    pub fn initial(&self, config: PomoConfig) -> Duration {
        match self {
            Self::Work => config.work_time,
            Self::Break => config.break_time,
            Self::LongBreak => config.long_break,
        }
    }
}
