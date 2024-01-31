// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Bank {
    address constant GUARD = address(1);
    address public admin;

    struct account {
        address user;
        uint256 balance;
    }

    mapping(address => uint256) private _balance;
    mapping(address => address) private _nextUsers;  // 总存入额排行榜，不包含已取出的
    uint256 constant SIZE_LIMIT = 3;
    

    modifier onlyAdmin {
        require(msg.sender == admin, "Not Admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }
    
    function balanceOf(address depositor) external view returns(uint256) {
        return _balance[depositor];
    }
    
    function displayLeadboard() external view returns(address[] memory) {
        address[] memory leadboard = new address[](SIZE_LIMIT);

        address current = _nextUsers[GUARD];
        for(uint256 i = 0; i < SIZE_LIMIT; ++i) {
            leadboard[i] = current;
            current = _nextUsers[current];
        }

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
        _balance[msg.sender] += amount;
        uint256 balance = _balance[msg.sender];

        // 排行榜链表排序
        address next;
        address current = GUARD;
        for (uint256 i = 0; i < SIZE_LIMIT; ++i) {
            next = _nextUsers[current];
            if (next == msgSender) {
                return;
            }

            if (next == address(0)) {
                _nextUsers[current] = msg.sender;
                return;
            }

            if (balance > _balance[next]) {
                _nextUsers[current] = msg.sender;
                _nextUsers[msg.sender] = next;
                return;
            }

            current = next;
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