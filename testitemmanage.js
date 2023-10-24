const ItemManager = artifacts.require("./ItemManager.sol");

contract("ItemManager", accounts => {
    it("....should be able to add an item", async function() {
        const itemManagerInstance = await ItemManager.deployed();
        const itemName = "test1";
        const itemPrice = 500;
        const result = await itemManagerInstance.CreateItem(itemName,itemPrice,{from : accounts[0]});
        assert.equal(result.logs[0].args._itemIndex,0,"it is not the first item");
        const item = await itemManagerInstance.items(0);
        // console.log(item);
    //     assert.equal(result.logs[0].args._itemIndex,0,"there should be one itemindex in there")
    //     const item = await itemManagerInstance.items(0);
        assert.equal(item._identifier,itemName ,"The item has a diffrent identifier");
    // });
    })
})