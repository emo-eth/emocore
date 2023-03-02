// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { BaseSaltScorer } from "./lib/BaseSaltScorer.sol";

contract ZeroByteSaltScorer is BaseSaltScorer {
    constructor(address create2Factory) BaseSaltScorer(create2Factory) { }

    function _score(address addr)
        internal
        pure
        override
        returns (uint256 score)
    {
        (uint256 leading, uint256 total) = _countZeroes(addr);
        assembly {
            score := add(mul(leading, leading), total)
        }
    }

    function _countZeroes(address addr)
        internal
        pure
        returns (uint256 numLeading, uint256 numTotal)
    {
        assembly {
            let leadingInterrupted
            for { let i := 12 } lt(i, 32) { i := add(i, 1) } {
                let thisByte := byte(i, addr)
                let thisByteIsZero := iszero(thisByte)
                leadingInterrupted :=
                    or(iszero(thisByteIsZero), leadingInterrupted)
                numTotal := add(numTotal, thisByteIsZero)
                numLeading :=
                    add(numLeading, mul(thisByteIsZero, iszero(leadingInterrupted)))
            }
        }
    }
}
