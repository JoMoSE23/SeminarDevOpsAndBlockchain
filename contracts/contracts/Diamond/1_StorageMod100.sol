// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


import "./DiamondStorage.sol";
/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Storage is DiamondStorage{

    event numberUpdated(uint256 numberOld, uint256 numberNew);
    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num, uint scale) external returns (uint256) {
        MyStorage storage ms = myStorage();
        uint256 tmpNum = ms.num100;
        ms.num100 = num*scale;
        emit numberUpdated(tmpNum, ms.num100);
        return num*scale;
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256){
        MyStorage storage ms = myStorage();
        return ms.num100;
    }
}