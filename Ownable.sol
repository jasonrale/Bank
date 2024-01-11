// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface BigBank {
    function withdraw() external;
    function transferOwner(address owner) external;
}

contract Ownable {
    address public owner;

    modifier onlyOwner {
        require(msg.sender == owner, "Only Owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function transferBankOwner(address bigBank, address bankOwner) external onlyOwner{
        BigBank(bigBank).transferOwner(bankOwner);
    }

    function withdraw(address bigBank) external onlyOwner {
        BigBank(bigBank).withdraw();
    }

    receive() external payable {
    }
}