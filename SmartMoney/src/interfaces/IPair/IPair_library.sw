library ipair_abi;

use std::{
    std::address::Address;
    std::contract_id::ContractId;
    std::identity::Identity;
    std::vec::Vec;
    std::storage::StorageMap;
    std::option::Option;
    std::result::Result;
    std::assert::assert;
    std::revert::require;
    m  
}

abi IPair {
    #[storage(read, write)]
    fn factory
}