// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract SignatureExecutor is EIP712 {
    using ECDSA for bytes32;

    error ZeroAddress();
    error InvalidNonce();
    error InvalidSigner();
    error SignatureExpired();
    error ETHTransferFailed();
    error InsufficientBalance();
    bytes32 public constant EXECUTE_TYPEHASH =
    keccak256(
        "Execute(address to,uint256 amount,uint256 nonce,uint256 deadline)"
    );
    address immutable public owner;
    mapping(address => uint256) public nonces;

    constructor() EIP712("SignatureExecutor", "1") {
        owner = msg.sender;
    }

    receive() external payable {}

    function execute(
        address to,
        uint256 amount,
        uint256 nonce,
        uint256 deadline,
        bytes calldata signature
    ) external {

        if (to == address(0)) {
            revert ZeroAddress();
        }
        if (block.timestamp > deadline) {
            revert SignatureExpired();
        }
        if (nonce != nonces[owner]) {
            revert InvalidNonce();
        }

        bytes32 structHash = keccak256(abi.encode(
            EXECUTE_TYPEHASH,
            to,
            amount,
            nonce,
            deadline
        ));
        bytes32 digest = _hashTypedDataV4(structHash);
        address signer = digest.recover(signature);

        if (signer != owner) {
            revert InvalidSigner();
        }
        nonces[owner]++;

        if (address(this).balance < amount) {
            revert InsufficientBalance();
        }
        (bool success, ) = payable(to).call{value: amount}("");
        if (!success) {
            revert ETHTransferFailed();
        }
    }
    function getDigest(
        address to,
        uint256 amount,
        uint256 nonce,
        uint256 deadline
    ) external view returns (bytes32) {

        bytes32 structHash = keccak256(
            abi.encode(
                EXECUTE_TYPEHASH,
                to,
                amount,
                nonce,
                deadline
        ));
        return _hashTypedDataV4(structHash);
    }
}