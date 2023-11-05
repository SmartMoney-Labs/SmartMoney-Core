library ipair;

mod data_structures;
mod ifactory;

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
use ifactory::IFactory;
use core::ops::Eq;
use std::*;

abi Ipair {

    // return the address of the factory contract that deployed this contract
    pub fn factory() -> IFactory;

    // @dev return the address of the ERC20 as collateral
    // @return the address of the collateral ERC20
    pub fn collateral() -> u64;

    // @dev return the fee per second earned by liquidty providers
    // @dev must be downcasted to u16
    // @return the protocol fee per second following the UQO.40 format.
    pub fn fee() -> u64;

    // @dev return the protocol fee per second earned by the owner
    // @dev must be downcasted to u16
    // @return the protocol fee per second following the UQO.40 format
    pub fn protocol_fee() -> u64;

    // @dev return the fee stored  of the pool given maturity
    // @param maturity the unix smart money maturity of the pool
    // @return the fee in asset ERC20 stored in the pool
    pub fn fee_stored(maturity: u64) -> u64;

    // @dev return the protocol fee stored 
    // @return the protocol fee in asset ERC20 stored
    pub fn protocol_fee_stored() -> u64;

    // @dev returns the constant product state of a pool
    // @dev the Y state follows the UQ80.32 format 
    // @param maturity the unix smart money maturity of the pool
    // return x the x state
    // return y the y state
    // return z the z state
    pub fn constant_product(maturity: u64) -> u64;

    // @dev returns the asset ERC20 and collateral ERC20 balances of a pool
    // @param maturity the unix smart money maturity of the pool
    // @return the asset ERC20 and collateral erc20 locked
    pub fn total_reserves(maturity: u64) -> Tokens; 

    // returns the total liquidity supply in a pool
    pub fn total_liquidity(maturity: u64) -> u64;

    
    // returns the liquidity balance of a user in a pool
    pub fn liquidity_off(maturity: u64, owner: Address) -> u64;

    // returns the total claims of a pool
    pub fn total_claims(maturity: u64) -> Claims;

    // returns the claims of a user in a pool
    pub fn claims_of(maturity: u64, owner: Address) -> Claims;

    // returns the total debt created
    pub fn total_debt_created(maturity: u64) -> u128;   

    // returns the numbers of dues owned by owner
    pub fn total_due_of(maturity: u64, owner: Address) -> u64;

    // returns a collateralized debt of a user in a pool
    // #[storage(write)]
    pub fn due_of(maturity: u64, owner: Address, id: u64) -> Due;

    pub fn due_of(maturity: u64, owner: Address, id: u64) -> Due;
}