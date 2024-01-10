// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    address public admin;
    address[] private leadboard;
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
    
    function displayLeadboard() external view returns(address[] memory) {
        return leadboard;
    }
    
    function withdraw() external onlyAdmin {
        uint256 amount = address(this).balance;
        require(amount > 0, "Insufficient balance");
        payable(msg.sender).transfer(amount);
    }

    receive() external payable {
        uint256 amount = msg.value;
        address msgSender = msg.sender;
        require(amount > 0, "Incorrect Value");
        balance[msg.sender] = amount;

        uint256 min = amount;
        uint8 modifyIndex = 3;
        if(leadboard.length < 3) {
            leadboard.push(msgSender);
        } else {
            for (uint8 i = 0; i < 3; i++) {
                if (balance[leadboard[i]] < min ) {
                    min = balance[leadboard[i]];
                    modifyIndex = i;
                }
            }
            leadboard[modifyIndex] = msgSender;
        }
    }
}