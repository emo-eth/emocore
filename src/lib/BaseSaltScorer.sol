// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

abstract contract BaseSaltScorer {
    address internal immutable CREATE2_FACTORY;

    constructor(address create2Factory) {
        CREATE2_FACTORY = create2Factory;
    }

    function _score(address addr)
        internal
        view
        virtual
        returns (uint256 score);
}
