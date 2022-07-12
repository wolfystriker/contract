contract;

use wyvern_exchange_lib::WyvernExchange;
use nftlib::NFTLib;
use std::{
    storage::StorageMap,
    address::Address,
    assert::assert,
    chain::auth::{AuthError, msg_sender},
    identity::Identity,
    result::*,
    context::msg_amount,
    revert::revert,
};

struct TransferData {
    fee: u64,
    price: u64,
    is_sold: bool
}

storage {
    contract_address: b256 = 0x0000000000000000000000000000000000000000000000000000000000000000,
    owner: b256 = 0x0000000000000000000000000000000000000000000000000000000000000000,
    transfer_data: StorageMap<u64, TransferData> = StorageMap {}
}

// Store the zero address in a global variable for ease of use
const ZERO_ADDRESS: b256 = 0x0000000000000000000000000000000000000000000000000000000000000000;

// Get the message sender address
fn get_msg_sender() -> b256 {
    let sender: Result<Identity, AuthError> = msg_sender();

    if let Identity::Address(addr) = sender.unwrap() {
        return addr.into();
    } else {
        return ZERO_ADDRESS;
    }

    return ZERO_ADDRESS;
}

impl WyvernExchange for Contract {
    #[storage(write)]fn init(contract_address: b256) {
        let sender = get_msg_sender();

        assert(sender != ZERO_ADDRESS);

        storage.contract_address = contract_address;
        storage.owner = sender;
    }

    #[storage(read, write)]fn set_transfer_data(token_id: u64, fee: u64, price: u64) {
        let sender = get_msg_sender();

        assert(sender == storage.owner);

        storage.transfer_data.insert(token_id, TransferData { fee: fee, price: price, is_sold: false });
    }

    #[storage(read, write)]fn transfer_token(token_id: u64) {
        let owner = storage.owner;
        let value = msg_amount();
        let sender = get_msg_sender();
        let mut token_data = storage.transfer_data.get(token_id);

        assert(sender != ZERO_ADDRESS && sender != owner);
        assert(token_data.price > 0);
        assert(value > token_data.price);
        assert(token_data.is_sold == false);

        let contract_address = storage.contract_address;
        let nft_contract = abi(NFTLib, contract_address);

        nft_contract.approve(sender, token_id);
        nft_contract.transfer_from(owner, sender, token_id);

        token_data.is_sold = true;

        storage.transfer_data.insert(token_id, token_data);
    }
}
