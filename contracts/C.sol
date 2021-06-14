// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

interface ERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address _owner) external view returns (uint256 balance);

    function transfer(address _to, uint256 _value)
        external
        returns (bool success);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);

    function approve(address _spender, uint256 _value)
        external
        returns (bool success);

    function allowance(address _owner, address _spender)
        external
        view
        returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
}

contract C is ERC20 {
    using SafeMath for uint256;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    address private _contractOwner;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowance;

    constructor() {
        _name = "CToken";
        _symbol = "CCC";
        _decimals = 18;
        _totalSupply = 1000000000000000000000000;
        _contractOwner = msg.sender;
        _balances[msg.sender] = _totalSupply;
    }

    modifier restrictTransfer(
        address from,
        address to,
        uint256 amount
    ) {
        require(from == msg.sender);
        uint256 senderBalance = _balances[from];
        require(senderBalance >= amount);
        _;
    }

    modifier restrictTransferFrom(
        address source,
        address allowed,
        uint256 amount
    ) {
        uint256 allowedAmount = _allowance[source][allowed];
        require(allowedAmount > 0, "Amount should be more than 0.");
        require(allowedAmount >= amount, "Amount to large than allowed.");
        _;
    }

    modifier onlyOwner(address _owner) {
        require(msg.sender == _owner);
        _;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    function decimals() public view override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner)
        public
        view
        override
        returns (uint256 balance)
    {
        return _balances[_owner];
    }

    function transfer(address to, uint256 value)
        public
        override
        restrictTransfer(msg.sender, to, value)
        returns (bool success)
    {
        _transfer(msg.sender, to, value);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    )
        public
        override
        restrictTransferFrom(from, msg.sender, amount)
        returns (bool success)
    {
        _transferFrom(msg.sender, from, to, amount);

        return true;
    }

    function approve(address _spender, uint256 _value)
        public
        override
        returns (bool success)
    {
        _allowance[msg.sender][_spender] = _value;

        return true;
    }

    function allowance(address _owner, address _spender)
        public
        view
        override
        returns (uint256 remaining)
    {
        return _allowance[_owner][_spender];
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(amount);

        emit Transfer(from, to, amount);
    }

    function _transferFrom(
        address allowed,
        address from,
        address to,
        uint256 amount
    ) private {
        _allowance[from][allowed] = _allowance[from][allowed].sub(amount);
        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(amount);

        emit Transfer(from, to, amount);
    }
}
