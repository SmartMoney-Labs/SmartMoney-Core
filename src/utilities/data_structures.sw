library data_structures;

use core::ops::Eq;
use std::*;

abi data_structures {
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
}