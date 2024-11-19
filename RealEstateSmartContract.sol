// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RealEstateSmartContract {
    struct Property {
        uint id;
        string name;
        uint price; // REMINDER - Need to check payment in Wei*
        address owner;
        mapping(address -> uint) tokenHolders;
    }
    uint public propertyCount = 0; // Counting property ID
    mapping(uint -> Property) public properties;

    event PropertyListed(uint propertyId, string name, uint price, address owner);
    event TokenPurchased(uint propertyId, address buyer, uint tokens);
    event Ownershiptransferred(uint propertyId, address previousOwner, address newOwner);

}

function listProperty(string memory _name, uint _price, uint _totalTokens) public{

    require(_totalTokens > 0, "The total number of tokens must be more than 0");

    require(_price > 0, "The price mst be more than zero");

    propertyCount++;
    Property storage newProperty = properties[propertyCount];
    newProperty.id = propertyCount;
    newProperty.name = _name;
    newProperty.price = _price
    newPropety.owner = msg.sender;
    newProperty.totalTokens = _totalTokens;
    newProperty.tokensAvailable = _totalTokens;
    emit PropertyListed(propertyCount, _name, price, msg.sender);
    //Function will create a new property listed
}
