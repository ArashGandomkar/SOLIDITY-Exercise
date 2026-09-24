// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SafeEIP1967Proxy {
    bytes32 internal constant IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    bytes32 internal constant ADMIN_SLOT =
        0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    constructor(address _implementation) payable {
        _setImplementation(_implementation);
        _setAdmin(msg.sender);
    }

    function implementation()
        public
        view
        returns (address impl)
    {
        bytes32 slot = IMPLEMENTATION_SLOT;

        assembly {
            impl := sload(slot)
        }
    }

    function admin()
        public
        view
        returns (address adm)
    {
        bytes32 slot = ADMIN_SLOT;

        assembly {
            adm := sload(slot)
        }
    }

    function _setImplementation(
        address newImplementation
    ) internal {
        bytes32 slot = IMPLEMENTATION_SLOT;

        assembly {
            sstore(slot, newImplementation)
        }
    }

    function _setAdmin(
        address newAdmin
    ) internal {
        bytes32 slot = ADMIN_SLOT;

        assembly {
            sstore(slot, newAdmin)
        }
    }

    function upgradeTo(
        address newImplementation
    ) external {
        require(
            msg.sender == admin(),
            "NOT_ADMIN"
        );

        require(
            newImplementation.code.length > 0,
            "NOT_CONTRACT"
        );

        _setImplementation(newImplementation);
    }

    fallback() external payable {
        address impl = implementation();

        assembly {
            calldatacopy(
                0,
                0,
                calldatasize()
            )

            let result := delegatecall(
                gas(),
                impl,
                0,
                calldatasize(),
                0,
                0
            )

            returndatacopy(
                0,
                0,
                returndatasize()
            )

            switch result
            case 0 {
                revert(
                    0,
                    returndatasize()
                )
            }
            default {
                return(
                    0,
                    returndatasize()
                )
            }
        }
    }

    receive() external payable {}
}