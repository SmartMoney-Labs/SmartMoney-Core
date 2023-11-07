library ifactory;

mod data_structures;
mod ipair

use ipair::Ipair; 

use data_structures::{
    Tokens, 
    Claims, 
    Due, 
    State, 
    MintParam, 
    BurnParam, 
    LendParam, 
    WithdrawParam, 
    BorrowParam, 
    PayParam
}

use core::ops::Eq;
use std::address::Address;


abi Ifactory {
    pub fn owner() -> Address;

    pub fn pending_owner() -> Address;

    pub fn fee() -> u64;

    pub fn protocol_fee() -> u64;

    // develop IERC20 library
    // pub fn get_pair(asset: IERC20, collateral: IERC20) -> Ipair; 

    // // =============== Update ===============

    // develop IERC20 library
    // pub fn create_pair(asset: IERC20, collateral: IERC20) -> Ipair;


    pub fn set_pending_owner(_pending_owner: Address);

    pub fn accept_owner();
}