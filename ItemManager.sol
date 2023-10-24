//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "./Item12.sol";
// import "./Ownable.sol";

// contract Ownable {

//     address public _owner;
//     constructor (){ 
//         _owner = msg.sender;
//     }
//     /**
//     * @dev Throws if called by any account other than the owner. */
//     modifier onlyOwner() {
//         require(isOwner(), "Ownable: caller is not the owner"); _;
//     }
//     /**
//     * @dev Returns true if the caller is the current owner. */
//     function isOwner() public view returns (bool) { 
//         return (msg.sender == _owner);

//     }
// }

contract ItemManager {
    address public _owner;
    constructor(){
        _owner = msg.sender;
    }
    modifier onlyOwner() {
        require(isOwner(),"caller is not the owner");
        _;
    }
    function isOwner() public view returns(bool) {
        return (msg.sender == _owner);
    }
    enum SupplyChainState{created, paid, deleivered}

    struct S_Item {
        Item item;
        string _identifier;
        uint _ItemPrice;
        ItemManager.SupplyChainState _state;
    }

    event SupplyChainStep(uint _itemIndex,uint _Step,address _itemAddress);

    mapping(uint => S_Item) public items;
    uint itemIndex;

    function CreateItem(string memory _identifier,uint _ItemPrice) public onlyOwner {
        Item item = new Item(this,itemIndex,_ItemPrice);
        items[itemIndex].item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._ItemPrice = _ItemPrice;
        items[itemIndex]._state = SupplyChainState.created;
        emit SupplyChainStep( itemIndex, uint(items[itemIndex]._state),address(item));
        itemIndex++;
    }

    function triggerPayment(uint _itemIndex) public payable {
        require(items[_itemIndex]._ItemPrice == msg.value,"No partial payment accepted");
        require(items[_itemIndex]._state == SupplyChainState.created,"Item Is in the supply chain");
        items[_itemIndex]._state = SupplyChainState.paid;
        emit SupplyChainStep(itemIndex,uint(items[_itemIndex]._state),address(items[_itemIndex].item));
    }

    function triggerDeleivery(uint _itemIndex) public onlyOwner {
        require(items[_itemIndex]._state == SupplyChainState.paid,"Payment is not triggered yet");
        items[_itemIndex]._state = SupplyChainState.deleivered;
        emit SupplyChainStep(itemIndex,uint(items[_itemIndex]._state),address(items[_itemIndex].item));
    }
}