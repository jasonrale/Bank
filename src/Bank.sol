// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Test, console} from "forge-std/Test.sol";

contract Bank {
    address public admin;
    address[3] private leadboard;
    mapping(address => uint256) private balance;

    modifier onlyAdmin {
        require(msg.sender == admin, "Not Admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }
    
    function balanceOf(address depositor) external view returns(uint256) {
        return balance[depositor];
    }
    
    function displayLeadboard() external view returns(address[3] memory) {
        return leadboard;
    }

    function transferOwner(address owner) external onlyAdmin {
        admin = owner;
    }
    
    function withdraw() external onlyAdmin {
        uint256 amount = address(this).balance;
        require(amount > 0, "Insufficient balance");
        payable(msg.sender).transfer(amount);
    }

    function _desposit() internal {
        uint256 amount = msg.value;
        address msgSender = msg.sender;
        require(amount > 0, "Incorrect Value");
        balance[msg.sender] += amount;

        uint256 min = balance[msg.sender];
        uint8 modifyIndex = 3;
        for (uint8 i = 0; i < 3; i++) {
            if (leadboard[i] == msgSender) {
                return;
            }
            if (balance[leadboard[i]] < min) {
                min = balance[leadboard[i]];
                modifyIndex = i;
            }
        }
        if (modifyIndex < 3) {
            leadboard[modifyIndex] = msgSender;
        }
    }

    receive() external payable {
        _desposit();
    }
}

contract BigBank is Bank {
    modifier depositLimit {
        require(msg.value >= 0.001 ether, "Deposit Limit");
        _;
    }

    function desposit() external payable depositLimit  {
        super._desposit();
    }
}