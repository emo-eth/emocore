// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { BaseSaltScorer } from "./lib/BaseSaltScorer.sol";

contract ZeroNibbleSaltScorer is BaseSaltScorer {
    uint256 constant LEFT_NIBBLE_MASK = 0xF0;
    uint256 constant RIGHT_NIBBLE_MASK = 0x0F;

    constructor(address create2Factory) BaseSaltScorer(create2Factory) { }

    function _score(address addr)
        internal
        pure
        override
        returns (uint256 score)
    {
        (uint256 leadingZeroBytes, uint256 leadingZeroNibbles, uint256 total) =
            _countZeroes(addr);
        // S = L_B^2 + L_N + T
        ///@solidity memory-safe-assembly
        assembly {
            score :=
                add(
                    mul(leadingZeroBytes, leadingZeroBytes),
                    add(leadingZeroNibbles, total)
                )
        }
    }

    function _countZeroes(address addr)
        internal
        pure
        returns (
            uint256 numLeadingBytes,
            uint256 numLeadingNibbles,
            uint256 numTotal
        )
    {
        ///@solidity memory-safe-assembly
        assembly {
            let leadingInterrupted
            for { let i := 24 } lt(i, 64) { i := add(i, 1) } {
                // if i is odd, we're looking at a nibble and not a real byte
                let isByte := iszero(and(i, 1))

                // divide i by 2 to get index of the byte
                let byteIndex := shr(1, i)
                // load this byte whether or not we're looking at a nibble
                let thisByte := byte(byteIndex, addr)
                // determine if byte is zero, but only count it if current index
                // is not looking at a nibble
                // otherwise a zero byte will be counted twice
                let thisByteIsZero := and(iszero(thisByte), isByte)

                let thisNibble :=
                    and(
                        thisByte,
                        add(
                            mul(isByte, LEFT_NIBBLE_MASK),
                            mul(iszero(isByte), RIGHT_NIBBLE_MASK)
                        )
                    )
                let thisNibbleIsZero := iszero(thisNibble)

                leadingInterrupted :=
                    or(iszero(thisNibbleIsZero), leadingInterrupted)

                // only count uninterrupted nibbles
                numTotal := add(numTotal, thisByteIsZero)
                numLeadingBytes :=
                    add(
                        numLeadingBytes,
                        and(thisByteIsZero, iszero(leadingInterrupted))
                    )
                numLeadingNibbles :=
                    add(
                        numLeadingNibbles,
                        and(thisNibbleIsZero, iszero(leadingInterrupted))
                    )
            }
        }
    }
}
