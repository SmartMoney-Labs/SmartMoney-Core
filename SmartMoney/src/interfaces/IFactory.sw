library ifactory_abi;

use ipair_abi::*;
use core::ops::Eq;

use std::{
    address::Address,
    contract_id::ContractId,
    identity::Identity,
    vec::Vec,
    storage::StorageMap,
    option::Option,
    result::Result,
    assert::assert,
    revert::require,
    revert::revert,
    token::*,
};

abi IPair {
    #[storage(read)]
    fn owner() -> Address;

    #[storage(read)] 
    fn pending_owner() -> b256;

    #[storage(read)]
    fn fee() -> b256;

    #[storage(read)]
    fn protocol_fee() -> b256;

    #[storage(read, write)]
    fn get_pair(asset: ContractId, collateral: ContractId) -> Ipair;
}


pub struct CreatePair {
    asset: ContractId,
    collateral: ContractId,
    ipair: Ipair,
}

pub struct SetOwner {
    pending_owner: Address,
}  

pub struct AcceptOwner {
    owner: Address,
}

// function status
pub enum State {
    NotInitialized: (),
    Initialized: (),
}

impl Eq for State {
    fn eq(self, other: Self) -> bool {
        match(self, other) {
            (State::Initialized, State::Initialized) => true,
            (State::NotInitialized, State::NotInitialized) => true,
            _ => false, 
        }
    }
}