// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { CommitReveal } from "../../src/CommitReveal.sol";

contract TestCommitReveal is CommitReveal(5 minutes, 1 minutes) {
    function assertCommittedReveal(bytes32 computedCommitmentHash)
        external
        view
    {
        _assertCommittedReveal(computedCommitmentHash);
    }
}
