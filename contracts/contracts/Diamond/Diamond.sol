pragma solidity ^0.8.18;

import "./IDiamondCut.sol";
import "./DiamondStorage.sol";

//0x6057361d0000000000000000000000000000000000000000000000000000000000000005
//0x6ed28ed000000000000000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000004

contract Diamond is IDiamondCut, DiamondStorage{
    
 
    mapping(bytes4 => address) selectorToAddress;

    function getNumber10() public view returns(uint256 num){
        MyStorage storage ms = myStorage();
        return ms.num10;
    }

    function getNumber100() public view returns(uint256 num){
        MyStorage storage ms = myStorage();
        return ms.num100;
    }

    constructor(address r1, address r2, bytes4 s1, bytes4 s2){
        selectorToAddress[s1] = r1;
        selectorToAddress[s2] = r2;
    }

    fallback() external payable {
        // get facet from function selector
        address facet = selectorToAddress[msg.sig];
        require(facet != address(0));
        // Execute external function from facet using delegatecall and return any value.
        assembly {
            // copy function selector and any arguments
            calldatacopy(0, 0, calldatasize())
            // execute function call using the facet
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            // get any return value
            returndatacopy(0, 0, returndatasize())
            // return any return value or error back to the caller
            switch result
            case 0 {revert(0, returndatasize())}
            default {return (0, returndatasize())}
        }
    }

    function diamondCut(FacetCut[] calldata _diamondCut, address _init, bytes calldata _calldata) external{
        for (uint i = 0; i < _diamondCut.length; i++){
            if(_diamondCut[i].action == FacetCutAction.Add){
                for(uint k = 0; k < _diamondCut[i].functionSelectors.length; k++){
                    if(selectorToAddress[_diamondCut[i].functionSelectors[k]] == address(0)){
                    selectorToAddress[_diamondCut[i].functionSelectors[k]] = _diamondCut[i].facetAddress;
                    }
                }
            }

            if(_diamondCut[i].action == FacetCutAction.Replace){
                for(uint k = 0; k < _diamondCut[i].functionSelectors.length; k++){
                    if(selectorToAddress[_diamondCut[i].functionSelectors[k]] != address(0)){
                    selectorToAddress[_diamondCut[i].functionSelectors[k]] = _diamondCut[i].facetAddress;
                    }
                }
            }

            if(_diamondCut[i].action == FacetCutAction.Remove){
                for(uint k = 0; k < _diamondCut[i].functionSelectors.length; k++){
                    selectorToAddress[_diamondCut[i].functionSelectors[k]] = address(0);
                }
            }

            emit DiamondCut(_diamondCut, _init, _calldata);
        }
    }
}