library ipair_abi;

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
    // return the address of the factory contract
    #[stora(read, write)]
    fn factory(factory_address: Address);

    // return the address of the asset ERC20
    #[storage(read, write)]
    fn asset(borrowed_address: Address);

    // return the address of the ERC20 as collateral 
    #[storage(read, write)]
    fn collateral(collateral_address: Address);

    // return the fee per second earned by liquidity providers
    #[storage(read, write)]
    fn fee(providers_fee: b256) -> b256;

    // return the protocol fee per second earned by the owner
    #[storage(read, write)]
    fn protocol_fee(owner_fee: b256) -> b256;

    // return The protocol fee in asset ERC20 stored.
    #[storage(read, write)]
    fn protocol_fee_stored(protocol_fee: b256) -> b256;

    // return the constant product state of a pool
    #[storage(read, write)]
    fn constant_product();
}

pub struct Tokens { 
    asset: u64,
    collateral: u64,
}

pub struct Claims {
    bondPrincipal: u64,
    bondInterest: u64,
    insurancePrincipal: u64,
    insuranceInterest: u64,
}

pub struct Due {
    debt: u64,
    collateral: u64,
    startBlock: u64,
}

pub struct State {
    Tokens: reserves,
    feeStored: b256,
    totalLiquidity: b256,
    Claims: totalClaims,
    totalDebtCreated: u64,
    x: u64,
    y: u64,
    z: u64, 
}

pub struct Pool {
    state: State,
}

pub struct MintParam {
    maturity: b256,
    liquidity_to: Address,
    due_to: Address,
    x_increase: u64,
    y_increase: u64,
    z_increase: u64,
    // data: bytes (search how are the bytes in sway)
}

pub struct BurnParam {
    maturity: b256,
    asset_to: Address,
    collateral_to: Address,
    claims_in: Claims,
}

pub struct BorrowParam {
    maturity: b256,
    asset_to: Address,
    due_to: Address,
    x_decrease: u64,
    y_increase: u64,
    z_increase: u64,
    // data: bytes (search how are the bytes in sway)
}

pub struct PayParam {
    maturity: b256,
    to: Address,
    owner: Address,
    ids: b256,
    assets_in: u64,
    collaterals_out: u64,
    // data: bytes
}


// Events

