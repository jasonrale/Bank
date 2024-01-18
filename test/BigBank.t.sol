// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {BigBank} from "../src/BigBank.sol";

contract BankTest is BigBank {
    BigBank public bank;
    address public admin = makeAddr("admin");

    function setUp() public {
        vm.prank(admin);
        bank = new BigBank();
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
