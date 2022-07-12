library NFTLib;

use std::{
    storage::StorageMap,
    address::Address,
    assert::assert,
    chain::auth::{AuthError, msg_sender},
    identity::Identity,
    result::*,
    revert::revert,
};

struct Token {
    owner: b256,
    token_id: u64,
    token_uri: str[10],
    approved: b256
}

abi NFTLib {
    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    /// function throws for queries about the zero address.
    /// @param owner An address for whom to query the balance
    /// @return The number of NFTs owned by `owner`, possibly zero
    fn balance_of(owner: b256) -> u64;

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    /// about them do throw.
    /// @param token_id The identifier for an NFT
    /// @return The address of the owner of the NFT
    fn owner_of(token_id: u64) -> b256;

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `to` is the zero address. Throws if
    ///  `token_id` is not a valid NFT.
    /// @param from The current owner of the NFT
    /// @param to The new owner
    /// @param token_id The NFT to transfer
    fn transfer_from(from: b256, to: b256, token_id: u64);

    /// @notice Change or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    /// Throws unless `msg_sender()` is the current NFT owner, or an authorized
    /// operator of the current owner.
    /// @param approved The new approved NFT controller
    /// @param token_id The NFT to approve
    fn approve(approved: b256, token_id: u64);

    /// @notice Enable or disable approval for a third party ("operator") to manage
    ///  all of `msg_sender()`'s assets
    /// @param operator Address to add to the set of authorized operators
    /// @param approved True if the operator is approved, false to revoke approval
    fn set_approval_for_all(operator: b256, approved: bool);

    /// @notice Get the approved address for a single NFT
    /// @dev Throws if `token_id` is not a valid NFT.
    /// @param token_id The NFT to find the approved address for
    /// @return The approved address for this NFT, or the zero address if there is none
    fn get_approved(token_id: u64) -> b256;

    /// @notice Query if an address is an authorized operator for another address
    /// @param owner The address that owns the NFTs
    /// @param operator The address that acts on behalf of the owner
    /// @return True if `operator` is an approved operator for `owner`, false otherwise
    fn is_approved_for_all(owner: b256, operator: b256) -> bool;

    // @notice Returns all data for a given token
    fn get_token(token_id: u64) -> Token;

    /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
    /// @dev Throws if `token_id` is not a valid NFT. URIs are defined in RFC
    ///  3986. The URI may point to a JSON file that conforms to the "ERC721
    ///  Metadata JSON Schema".
    fn token_uri(token_id: u64) -> str[10];

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    fn total_supply() -> u64;

    /// @notice Enumerate valid NFTs
    /// @dev Throws if `index` >= `totalSupply()`.
    /// @param index A counter less than `totalSupply()`
    /// @return The token identifier for the `index`th NFT,
    ///  (sort order not specified)
    fn token_by_index(index: u64) -> u64;

    /// @notice Enumerate NFTs assigned to an owner
    /// @dev Throws if `index` >= `balanceOf(owner)` or if
    ///  `owner` is the zero address, representing invalid NFTs.
    /// @param owner An address where we are interested in NFTs owned by them
    /// @param index A counter less than `balanceOf(owner)`
    /// @return The token identifier for the `index`th NFT assigned to `owner`,
    ///   (sort order not specified)
    fn token_of_owner_by_index(owner: b256, index: u64) -> u64;

    // @notice Mints a token to msg_sender()
    // @dev Throws if msg_sender() is zero address
    fn mint() -> Token;
}
