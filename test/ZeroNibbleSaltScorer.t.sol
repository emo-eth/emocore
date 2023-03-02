// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { BaseTest } from "./BaseTest.sol";
import { TestZeroNibbleSaltScorer } from
    "./helpers/TestZeroNibbleSaltScorer.sol";

contract ZeroNibbleSaltScorerTest is BaseTest {
    TestZeroNibbleSaltScorer test;

    function setUp() public virtual override {
        super.setUp();
        test = new TestZeroNibbleSaltScorer();
    }

    function testCountZeroes() public {
        (uint256 leading, uint256 nibbles, uint256 total) =
            test.countZeroes(address(0));
        assertEq(leading, 20);
        assertEq(nibbles, 40);
        assertEq(total, 20);

        (leading, nibbles, total) = test.countZeroes(address(1));
        assertEq(leading, 19, "leading");
        assertEq(nibbles, 39, "nibbles");
        assertEq(total, 19, "total");

        (leading, nibbles, total) =
            test.countZeroes(address(bytes20(bytes1(0x01))));
        assertEq(leading, 0, "leading");
        assertEq(nibbles, 1, "nibbles");
        assertEq(total, 19, "total");

        (leading, nibbles, total) =
            test.countZeroes(address(bytes20(bytes2(0x0001))));
        assertEq(leading, 1, "leading");
        assertEq(nibbles, 3, "nibbles");
        assertEq(total, 19, "total");

        (leading, nibbles, total) =
            test.countZeroes(address(uint160(uint160(type(uint136).max) << 12)));
        assertEq(leading, 1, "leading");
        assertEq(nibbles, 3, "nibbles");
        assertEq(total, 2, "total");
    }

    function testScore() public {
        uint256 score = test.score(address(type(uint160).max));
        assertEq(score, 0, "score");
        score = test.score(address(uint160(type(uint152).max)));
        assertEq(score, 4, "score");
        score = test.score(address(uint160(uint160(type(uint136).max) << 12)));
        assertEq(score, 6, "score");
        score = test.score(address(uint160(type(uint144).max)));
        assertEq(score, 10, "score");
        score = test.score(address(0));
        assertEq(score, 460, "score");
    }
}
