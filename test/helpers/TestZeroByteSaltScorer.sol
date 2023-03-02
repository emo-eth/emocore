// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { ZeroByteSaltScorer } from "../../src/ZeroByteSaltScorer.sol";
import { IMMUTABLE_CREATE2_FACTORY } from "../../src/lib/Constants.sol";

contract TestZeroByteSaltScorer is
    ZeroByteSaltScorer(IMMUTABLE_CREATE2_FACTORY)
{
    function score(address addr) public pure returns (uint256) {
        return _score(addr);
    }

    function countBytes(address addr)
        public
        pure
        returns (uint256 leading, uint256 total)
    {
        return _countZeroes(addr);
    }
}
