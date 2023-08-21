// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract PianwiBUNN{
    uint256 public totalsupply;
    string public name;
    string public symbol;
    // uint8 public decimal;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping (address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256);

    event Approval(address indexed owner, address indexed spender, uint256);

    constructor(string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;

        _mint(msg.sender, 1000e18);
        _burn(msg.sender, 1000e18);
    }

    function decimal() public pure returns (uint8){
        return 18;
    }

    function transfer(address recipient, uint256 amount) external returns (bool){
        return _transfer(msg.sender, recipient, amount);
    }

    function _transferFrom(address sender, address recipient, uint256 amount) external returns (bool){
        uint256 currentBalance = allowance[sender][msg.sender];
        require(currentBalance >= amount, "ERC20 transfer amount must exceed allowance");

        allowance[sender][msg.sender] = currentBalance - amount;

        emit Approval(sender, recipient, amount);

        return _transfer(sender, recipient, amount);
    }

    function approve(address spender, uint256 amount) external returns (bool){
        require(spender != address(0), "ERC20 approved to the address");
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) private returns (bool){
        
        require(recipient != address(0), "ERC20 transfer to address 0");
        
        uint256 senderBalance = balanceOf[sender];

        require(senderBalance >= amount, "ERC20 transfer amount exceeds balance");

        balanceOf[msg.sender]= senderBalance - amount;

        balanceOf[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        return true;
    }

    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "ERC20 transfer to address 0");

        totalsupply += amount;
        balanceOf[to] += amount;

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        require(from != msg.sender, "Invalid Wallet Address");

        totalsupply -= amount;
        balanceOf[from] -= amount;
    }

}
