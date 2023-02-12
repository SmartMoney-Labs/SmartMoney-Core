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
    std::revert::revert;
}

abi IPair {
    // return the address of the factory contract
    #[storage(read, write)]
    fn factory(factory_address: Address);

    // return the address of the asset ERC20
    #[storage(read, write)]
    fn asset(borrowed_address: Address);

    // return the address of the ERC20 as collateral 
    #storage(read, write)
    fn collateral(collateral_address: Address);

    // return the fee per second earned by liquidity providers
    #storage(read, write)
    fn fee(providers_fee: u64) -> u64;

    // return the protocol fee per second earned by the owner
    #storage(read, write)
    fn protocolfee(owner_fee: u64) -> u64;
}