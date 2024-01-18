// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Bank} from "src/Bank.sol";

contract BankTest is Test {
    Bank public bank;
    address public bankAddr;
    address public admin = makeAddr("admin");
    address public jason = makeAddr("jason");
    address public lisa = makeAddr("lisa");
    address public martin = makeAddr("martin");
    address public alice = makeAddr("alice");


    function setUp() public {
        deal(jason, 10 ether);
        deal(lisa, 10 ether);
        deal(martin, 10 ether);
        deal(alice, 10 ether);

        vm.prank(admin);
        bank = new Bank();
        bankAddr = address(bank);
    }

    function test_desposit() public {
        vm.prank(jason);
        bankAddr.call{value: 1 ether}("");
        assertEq(bank.balanceOf(jason), 1 ether);

        vm.prank(jason);
        bankAddr.call{value: 1 ether}("");
        assertEq(bank.balanceOf(jason), 2 ether);

        vm.prank(lisa);
        bankAddr.call{value: 4 ether}("");
        assertEq(bank.balanceOf(lisa), 4 ether);

        vm.prank(martin);
        bankAddr.call{value: 3 ether}("");
        assertEq(bank.balanceOf(martin), 3 ether);

        vm.prank(alice);
        bankAddr.call{value: 5 ether}("");
        assertEq(bank.balanceOf(alice), 5 ether);

        assertEq(abi.encode(bank.displayLeadboard()), abi.encode([alice, lisa, martin])); 
    }

    //forge-config: default.fuzz.runs = 200
    function testFuzz_desposit(uint256 value) public {
        deal(alice, value);
        vm.prank(alice);
        bankAddr.call{value: value}("");
        assertEq(bank.balanceOf(alice), value);
    }

    function test_withdraw() public {
        vm.prank(alice);
        bankAddr.call{value: 5 ether}("");
        vm.prank(admin);
        bank.withdraw();
        assertEq(admin.balance, 5 ether);
    }
}
