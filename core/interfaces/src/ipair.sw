library ipair;

mod ifactory;

use ifactory::IFactory;
use core::ops::Eq;

use std::*;

abi Ipair {
    // ========== View ==========


    // @dev return the address of the factory contract that deployed
    // @return the address of the factory contract
    #[storage(read, write)]
    pub fn factory() -> IFactory;

    // @dev return the address of the ERC20 being lent and borrowed
    // @return the address of the asset ERC20
    #[storage(read, write)]
    pub fn asset() -> IERC20;

    // @dev return the address of the ERC20 as collateral
    // @return the address of the collateral ERC20
    #[storage(read)]
    pub fn collateral() -> u64;

    // @dev return the fee per second earned by liquidty providers
    // @dev must be downcasted to u16
    // @return the protocol fee per second following the UQO.40 format.
    #[storage(read, write)]
    pub fn fee() -> u64;

    // @dev return the protocol fee per second earned by the owner
    // @dev must be downcasted to u16
    // @return the protocol fee per second following the UQO.40 format
    #[storage(read, write)]
    pub fn protocol_fee() -> u64;

    // @dev return the fee stored  of the pool given maturity
    // @param maturity the unix smart money maturity of the pool
    // @return the fee in asset ERC20 stored in the pool
    #[storage(read, write)]
    pub fn fee_stored(maturity: u64) -> u64;

    // @dev return the protocol fee stored 
    // @return the protocol fee in asset ERC20 stored
    #[storage(read, write)]
    pub fn protocol_fee_stored() -> u64;

    // @dev returns the constant product state of a pool
    // @dev the Y state follows the UQ80.32 format 
    // @param maturity the unix smart money maturity of the pool
    // return x the x state
    // return y the y state
    // return z the z state
    #[storage(read, write)]
    pub fn constant_product(maturity: u64) -> u64;

    // @dev returns the asset ERC20 and collateral ERC20 balances of a pool
    // @param maturity the unix smart money maturity of the pool
    // @return the asset ERC20 and collateral erc20 locked
    #[storage(read, write)]
    pub fn total_reserves(maturity: u64) -> Tokens; 

    // returns the total liquidity supply in a pool
    #[storage(read, write)]
    pub fn total_liquidity(maturity: u64) -> u64;

    
    // returns the liquidity balance of a user in a pool
    #[storage(write)]
    pub fn liquidity_off(maturity: u64, owner: Address) -> u64;

    
    // returns the total claims of a pool
    #[storage(write)]
    pub fn total_claims(maturity: u64) -> Claims;

    // returns the claims of a user in a pool
    #[storage(write)]
    pub fn claims_of(maturity: u64, owner: Address) -> Claims;

    // returns the total debt created
    // #[storage(write)]
    pub fn total_debt_created(maturity: u64) -> u128;   

    // returns the numbers of dues owned by owner
    #[storage(write)]
    pub fn total_due_of(maturity: u64, owner: Address) -> u64;

    // returns a collateralized debt of a user in a pool
    #[storage(write)]
    pub fn due_of(maturity: u64, owner: Address, id: u64) -> Due;



    // ========== Structs ==========

    pub struct Tokens {
       asset: u64,
       collateral: u64, 
    }

    pub struct Claims {
        bond_principal: u64,
        bond_interest: u64,
        insurance_principal: u64,
        insurance_interest: u64,
    }  

    pub struct Due {
        debt: u64,
        collateral: u64,
        start_block: u32,
    }

    pub struct State {
        reserves: Tokens,
        fee_stored: b256,
        total_liquidity: b256,
        total_claims: Claims,
        total_debt_created: u64,
        x: u64,
        y: u64,
        z: u64,
    }

    pub struct Pool {
        state: State,
        map: StorageMap<Address, b256> = StorageMap {liquidities},
        map: StorageMap<Address, Claims> = StorageMap {claims},
        map: StorageMap<Address, Due[]> = StorageMap {dues},        
        
    }

    pub struct MintParam {
        maturity: b256,
        liquidity_to: Address,
        due_to: Address,
        x_increase: u64,
        y_increase: u64,
        z_increase: u64,
        data: bytes,
    }

    pub struct BurnParam {
        maturity: b256,
        asset_to: Address,
        collateral_to: Address,
        liquidity_in: b256,
    }

    pub struct LendParam {
        maturity: b256,
        bond_to: Address,
        insurance_to: Address,
        x_increase: u64,
        y_decrease: u64,
        z_decrease: u64,
    }

    pub struct WithdrawParam {
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
        data: bytes,
    }

    pub struct PayParam {
        maturity: b256,
        to: Address,
        owner: Address,
        ids: b256[],
        assets_in: u64[],
        collaterals_outs: u64[],
        data: bytes,
    }


    // ========== Events ==========

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
        collaterals_out: u64,
        asset_in: u64,
        collateral_out: u64,
    }

    struct CollateralProtocolFee {
        sender: Address,
        to: Address,
        protocol_fee_out: b256,
    }


}