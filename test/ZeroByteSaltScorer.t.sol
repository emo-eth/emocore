// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { BaseTest } from "./BaseTest.sol";
import { TestZeroByteSaltScorer } from "./helpers/TestZeroByteSaltScorer.sol";

contract ZeroByteSaltScorerTest is BaseTest {
    TestZeroByteSaltScorer test;

    function setUp() public virtual override {
        super.setUp();
        test = new TestZeroByteSaltScorer();
    }

    function testCountBytes() public {
        (uint256 leading, uint256 total) = test.countBytes(address(0));
        assertEq(leading, 20);
        assertEq(total, 20);

        (leading, total) = test.countBytes(address(1));
        assertEq(leading, 19, "leading");
        assertEq(total, 19, "total");

        (leading, total) = test.countBytes(address(bytes20(bytes1(0x01))));
        assertEq(leading, 0, "leading");
        assertEq(total, 19, "total");

        (leading, total) = test.countBytes(address(bytes20(bytes2(0x0001))));
        assertEq(leading, 1, "leading");
        assertEq(total, 19, "total");
    }

    function testScore() public {
        uint256 score = test.score(address(type(uint160).max));
        assertEq(score, 0, "score");
        score = test.score(address(uint160(type(uint152).max)));
        assertEq(score, 2, "score");
        score = test.score(address(uint160(uint160(type(uint144).max) << 8)));
        assertEq(score, 3, "score");
        score = test.score(address(uint160(type(uint144).max)));
        assertEq(score, 6, "score");
        score = test.score(address(0));
        assertEq(score, 420, "score");
    }
}
