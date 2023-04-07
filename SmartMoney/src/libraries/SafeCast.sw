library safe_cast;

enum sucsf_num {
    num: b256,
}

enum numError {
    invalidNumber: (u8, u16, u32, u64, u128) 
}
// convert from b256 to u128
fn verify_number(number: U256) -> Result<num, numError> {
    match review {
        1 => Ok(sucsf_num<=u128::MAX.into()),
        _ => Err(numError::invalidNumber),
    };
    fn convert_to_u128(number: b256) -> (u128) {
        number.as_u128()
    }
}

