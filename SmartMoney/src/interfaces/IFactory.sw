library ifactory_abi;

use core::ops::Eq;

use std::{
    std::address::Address,
    std::contract_id::ContractId,
    std::identity::Identity,
    std::vec::Vec,
    std::storage::StorageMap,
    std::option::Option,
    std::result::Result,
    std::assert::assert,
    std::revert::require,
    std::revert::revert,
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

    // #[storage(read, write)]
    // fn set_pair(asset)
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