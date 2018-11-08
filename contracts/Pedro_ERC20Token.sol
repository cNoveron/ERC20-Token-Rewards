// solium-disable linebreak-style
pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract Pedro_ERC20Token is StandardToken {
    string public name = "Pedro Token";
    string public symbol = "PEDRO";
    uint public decimals = 2;
    uint public INITIAL_SUPPLY = 255000000 * 10**uint(decimals);

    constructor() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
    }
}
