library ipair;
mod data_structures;

use data_structures::{Tokens, Claims, Due, State}

use core::ops::Eq;
use std::*;

abi Ipair {
    pub fn due_of(maturity: u64, owner: Address, id: u64) -> Due;
}