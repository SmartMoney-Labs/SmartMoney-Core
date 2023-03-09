library ipair_abi;

use ifactory_abi::*;

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

    /// VIEW FUNCTIONS ////

    // return the address of the factory contract
    #[storage(read, write)]
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
    fn constant_product(maturity: b256);

    // returns the asset ERC20 and collateral ERC20 balances of a Pool
    #[storage(read, write)]
    fn total_reserves(maturity: b256);

    // returns the total liquidity supply of a Pool
    #[storage(read, write)]
    fn total_liquidity(maturity: b256, owner: Address);

    // returns the liquidity balance of a user in a pool
    #[storage(read, write)]
    fn liquidity_of(maturity: b256, owner: Address);

    // returns the total claims of a pool
    #[storage(read, write)]
    fn total_claims(maturity: b256);

    // returns the claims of a user in a Pool
    #[storage(read, write)]
    fn claims_of(maturity: b256, owner: Address);

    // return the total debt created
    #[storage(read, write)]
    fn total_debt_created(maturity: b256);

    // returns the number of dues owned by owner
    #[storage(read, write)]
    fn total_dues_of(maturity: b256, owner: Address);

    // returns a collateralized debt of a user in a pool
    #[storage(read, write)]
    fn due_of(maturity: b256, owner: Address, id: b256);

    /// UPDATE FUNCTIONS ///

    #[storage(read, write)]
    fn mint() -> (bool, u64);

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

// Emits when the state gets updated.

struct Sync {
    maturity: b256,
    x: u64,
    y: u64,
    z: u64,
}

struct Mint {
    maturity: b256,
    sender: Address,
    liquidity_to: Address,
    due_to: Address,
    asset_in: b256,
    liquidity_out: b256,
    id: b256,
    due_out: Due,
    fee_in: b256,
}

struct Burn {
    maturity: b256,
    sender: Address, 
    asset_to: Address, 
    collateral_to: Address,
    liquidity_in: b256,
    asset_out: b256,
    collateral_out: u64,
    fee_out: b256,
}

struct Lend {
    maturity: b256,
    sender: Address,
    bond_to: Address,
    insurance_to: Address,
    asset_in: b256,
    claims_out: Claims,
    fee_in: b256,
    protocol_fee_in: b256,
}

struct Withdraw {
    maturity: b256,
    sender: Address,
    asset_to: Address,
    collateral_to: Address,
    claims_in: Claims,
    tokens_out: Tokens,
}

struct Borrow {
    maturity: b256,
    sender: Address,
    asset_to: Address,
    due_to: Address,
    asset_out: b256,
    id: b256,
    due_out: Due,
    fee_in: b256,
    protocol_fee_in: b256,
}

struct Pay {
    maturity: b256,
    sender: Address,
    to: Address,
    owner: Address,
    ids: b256,
    assets_in: u64,
    collaterals_outs: u64,
    asset_in: u64,
    collateral_out: u64,
}

struct CollectProtocolFee {
    sender: Address,
    to: Address,
    protocol_fee_out: b256,
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