pragma solidity ^0.8.2;

//import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}



contract Owned {
    /* Define owner of the type address */
    address owner;
    
    /**
     * Modifiers partially define a function and allow you to augment other functions.
     * The rest of the function continues at _;
     */
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    /* This function is executed at initialization and sets the owner of the contract */
    constructor() public { 
        owner = msg.sender; 
    }
}

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
abstract contract ERC20 {
    uint public _totalSupply;
    function totalSupply() public view virtual returns (uint);
    function balanceOf(address who) public view virtual returns (uint256);
    //function transfer(address to, uint value) public view virtual;
    function transfer(address to, uint tokens) public virtual returns (bool success);
    
    function transferFrom(address from, address to, uint256 tokens) public virtual returns (bool success);
    
    function allowance(address tokenOwner, address spender) public view virtual returns (uint remaining);
    
    function approve(address spender, uint tokens) public virtual returns (bool success);
    
   // function _mint(address account, uint256 amount) internal virtual returns (bool success);
     
    event Transfer(address indexed from, address indexed to, uint tokens);
    
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    //event Transfer(address indexed from, address indexed to, uint value);
}

/*contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}*/





contract RimmingToken is  ERC20, Owned{
    
    using SafeMath for uint;
    
    string public symbol;
    string public  name;
    uint8 public decimals;
    //uint _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;


    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor() public {
        symbol = "RIMMING2";
        name = "RIMMINGToken2";
        decimals = 18;
        _totalSupply = 1000000 * 10**uint(decimals);
        //_totalSupply = 10000000;
        balances[owner] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
    }
    
    
    function burn(uint _value) public returns (bool sucess) {
        require(balances[msg.sender] >= _value);
        
        balances[msg.sender] -= _value;
        _totalSupply -= _value;
        return true;
    } 
    
     function mint(address account, uint256 amount) public virtual {
        require(account != address(0), "ERC20: mint to the zero address");

         _totalSupply += amount;
        balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }
    
    
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }


    function balanceOf(address _owner) public view virtual override returns (uint256) {
        return balances[_owner];
  }

    
   function transfer(address receiver, uint numTokens) public virtual override returns (bool success) {
          require(numTokens <= balances[msg.sender]);
          balances[msg.sender] = balances[msg.sender].sub(numTokens);
          balances[receiver] = balances[receiver] + numTokens;
          emit Transfer(msg.sender, receiver, numTokens);
          return true;
}
    
    function transferFrom(address owner, address buyer, uint256 numTokens) public virtual override returns (bool success) {
          require(buyer != address(0));
          require(numTokens <= balances[owner], "STUCK AT OWNER");
          require(numTokens <= allowed[owner][msg.sender], "STUCK AT ALLOWED");
          balances[owner] = balances[owner].sub(numTokens);
          allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
          balances[buyer] = balances[buyer] + numTokens;
          
          emit Transfer(owner, buyer, numTokens);
         // transfer(buyer, numTokens);
        //approve(buyer, numTokens);
          return true;
}
    
        // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------
    function allowance(address tokenOwner, address spender) public virtual override view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }


    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account. The `spender` contract function
    // `receiveApproval(...)` is then executed
    // ------------------------------------------------------------------------
    /*function approveAndCall(address spender, uint tokens, bytes data) public virtual override returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }*/
    
    function approve(address spender, uint tokens) public virtual override returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
}




