// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { ZeroNibbleSaltScorer } from "../../src/ZeroNibbleSaltScorer.sol";
import { IMMUTABLE_CREATE2_FACTORY } from "../../src/lib/Constants.sol";

contract TestZeroNibbleSaltScorer is
    ZeroNibbleSaltScorer(IMMUTABLE_CREATE2_FACTORY)
{
    function score(address addr) public pure returns (uint256) {
        return _score(addr);
    }

    function countZeroes(address addr)
        public
        pure
        returns (uint256 leading, uint256 nibble, uint256 total)
    {
        return _countZeroes(addr);
    }
}
