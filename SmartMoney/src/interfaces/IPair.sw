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
    fn fee(providers_fee: U256) -> U256;

    // return the protocol fee per second earned by the owner
    #[storage(read, write)]
    fn protocol_fee(owner_fee: U256) -> U256;

    // return The protocol fee in asset ERC20 stored.
    #[storage(read, write)]
    fn protocol_fee_stored(protocol_fee: U256) -> U256;

    // return the constant product state of a pool
    #[storage(read, write)]
    fn constant_product(maturity: U256);

    // returns the asset ERC20 and collateral ERC20 balances of a Pool
    #[storage(read, write)]
    fn total_reserves(maturity: U256);

    // returns the total liquidity supply of a Pool
    #[storage(read, write)]
    fn total_liquidity(maturity: U256, owner: Address);

    // returns the liquidity balance of a user in a pool
    #[storage(read, write)]
    fn liquidity_of(maturity: U256, owner: Address);

    // returns the total claims of a pool
    #[storage(read, write)]
    fn total_claims(maturity: U256);

    // returns the claims of a user in a Pool
    #[storage(read, write)]
    fn claims_of(maturity: U256, owner: Address);

    // return the total debt created
    #[storage(read, write)]
    fn total_debt_created(maturity: U256);

    // returns the number of dues owned by owner
    #[storage(read, write)]
    fn total_dues_of(maturity: U256, owner: Address);

    // returns a collateralized debt of a user in a pool
    #[storage(read, write)]
    fn due_of(maturity: U256, owner: Address, id: U256);

    /// UPDATE FUNCTIONS ///

    // Add liquidity into a Pool by a liquidity provider.
    #[storage(read, write)]
    fn mint() -> (U256, due_out);

    // Remove liquidity from a Pool by a liquidity provider.
    #[storage(read, write)]
    fn burn() -> (u64, U256);

    // Lend asset ERC20 into the Pool.
    #[storage(read, write)]
    fn lend() -> (U256, claims_out);

    // Withdraw asset ERC20 and/or collateral ERC20 for lenders.
    #[storage(read, write)]
    fn withdraw() -> tokens_out;

    // Borrow asset ERC20 from the Pool.
    #[storage(read, write)]
    fn borrow() -> (asset_out, id, due_out);

    // Pay asset ERC20 into the Pool to repay debt for borrowers.
    #[storage(read, write)]
    fn pay() -> u64;

    #[storage(read, write)]
    fn collateral_protocol_fee(too: Address) ->  U256;
}

pub struct Tokens { 
    asset: U128,
    collateral: U128,
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
    feeStored: U256,
    totalLiquidity: U256,
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
    maturity: U256,
    liquidity_to: Address,
    due_to: Address,
    x_increase: u64,
    y_increase: u64,
    z_increase: u64,
    // data: bytes (search how are the bytes in sway)
}

pub struct BurnParam {
    maturity: U256,
    asset_to: Address,
    collateral_to: Address,
    claims_in: Claims,
}

pub struct BorrowParam {
    maturity: U256,
    asset_to: Address,
    due_to: Address,
    x_decrease: u64,
    y_increase: u64,
    z_increase: u64,
    // data: bytes (search how are the bytes in sway)
}

pub struct PayParam {
    maturity: U256,
    to: Address,
    owner: Address,
    ids: U256,
    assets_in: u64,
    collaterals_out: u64,
    // data: bytes
}


// Events

// Emits when the state gets updated.

struct Sync {
    maturity: U256,
    x: u64,
    y: u64,
    z: u64,
}

struct Mint {
    maturity: U256,
    sender: Address,
    liquidity_to: Address,
    due_to: Address,
    asset_in: U256,
    liquidity_out: U256,
    id: U256,
    due_out: Due,
    fee_in: U256,
}

struct Burn {
    maturity: U256,
    sender: Address, 
    asset_to: Address, 
    collateral_to: Address,
    liquidity_in: U256,
    asset_out: U256,
    collateral_out: U128,
    fee_out: U256,
}

struct Lend {
    maturity: U256,
    sender: Address,
    bond_to: Address,
    insurance_to: Address,
    asset_in: U256,
    claims_out: Claims,
    fee_in: U256,
    protocol_fee_in: U256,
}

struct Withdraw {
    maturity: U256,
    sender: Address,
    asset_to: Address,
    collateral_to: Address,
    claims_in: Claims,
    tokens_out: Tokens,
}

struct Borrow {
    maturity: U256,
    sender: Address,
    asset_to: Address,
    due_to: Address,
    asset_out: U256,
    id: U256,
    due_out: Due,
    fee_in: U256,
    protocol_fee_in: U256,
}

struct Pay {
    maturity: U256,
    sender: Address,
    to: Address,
    owner: Address,
    ids: U256,
    assets_in: u64,
    collaterals_outs: u64,
    asset_in: u64,
    collateral_out: u64,
}

struct CollectProtocolFee {
    sender: Address,
    to: Address,
    protocol_fee_out: U256,
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