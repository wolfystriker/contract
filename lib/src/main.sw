library wyvern_exchange_lib;

use std::storage::StorageMap;

// Keep the necessary data 
// for a transfer of a token
struct TransferData {
    fee: u64,
    price: u64,
    is_sold: bool
}

abi WyvernExchange {
    // Init the exchange
    // @notice This function must be called after the contract is deployed
    // to make sure that it's properly constructed
    // @param { b256 } contract_address | The address of the contract that the exchange is being inittted for
    #[storage(write)]fn init(contract_address: b256);

    // Set the transfer data for a token
    // @param { u64 } token_id
    // @param { u64 } fee
    // @param { u64 } price
    #[storage(read, write)]fn set_transfer_data(token_id: u64, fee: u64, price: u64);

    // Make a token transfer
    // @dev Throws if the amount send is lower than the 
    // requested price, if the msg_sender is the owner of the token,
    // if the token transfer doesn't exit,
    // if the contract owner is not the owner of the nft
    // @param { u64 } token_id | The ID of the token to transfer
    // contract
    #[storage(read, write)]fn transfer_token(token_id: u64);
}
