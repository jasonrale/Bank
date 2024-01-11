#### Bank.sol 包含两个合约，其中BigBank合约继承Bank合约
#### Ownable.sol 是管理员合约，只有Ownable合约可以withdraw，调用withdraw方法会把BigBank合约中的ETH全部transfer到Ownable合约