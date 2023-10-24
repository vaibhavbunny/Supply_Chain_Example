//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "./ItemManager.sol";
contract Item {
    uint public index;
    uint public priceInwei;
    uint public pricePaid;

    ItemManager parentContract;

    constructor(ItemManager _parentContract,uint _index,uint _priceInwei) {
        parentContract = _parentContract;
        index = _index;
        priceInwei = _priceInwei;
    }
    receive() external payable {
        // instead of using .transfer here we will use .call() on function as to it is a low level function consuming l
        // less gas. as compared to transfer function.
        require(pricePaid == 0,"ites is already paid");
        require(priceInwei == msg.value,"Pay Exact Price");
        pricePaid += msg.value;
        (bool success, ) = address(parentContract).call{value: msg.value}(abi.encodeWithSignature("triggerPayment(uint256)",index));
        require(success,"Transaction wasn't successfull cancelling");
    }
}