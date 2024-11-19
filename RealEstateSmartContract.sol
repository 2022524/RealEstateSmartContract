// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RealEstateSmartContract {
    struct Property {
        uint id;
        string name;
        uint price; // REMINDER - Need to check payment in Wei*
        address owner;
        mapping(address => uint) tokenHolders;
    }

    uint public propertyCount = 0; // Counting property ID
    mapping(uint => Property) public properties;

    event PropertyListed(uint propertyId, string name, uint price, address owner);
    event TokenPurchased(uint propertyId, address buyer, uint tokens);
    event Ownershiptransferred(uint propertyId, address previousOwner, address newOwner);

    modifier onlyOwner(uint propertyId){
        require(msg.sender == properties[propertyId].owner, "Not the property owner");
    }
    
    // Function will create a new property listed
    function listProperty(string memory _name, uint _price, uint _totalTokens) public{

        require(_price > 0, "The price mst be more than 0");
        require(_totalTokens > 0, "The total number of tokens must be more than 0");

        propertyCount++;
        Property storage newProperty = properties[propertyCount];
        newProperty.id = propertyCount;
        newProperty.name = _name;
        newProperty.price = _price;
        newProperty.owner = msg.sender;
        newProperty.totalTokens = _totalTokens;
        newProperty.tokensAvailable = _totalTokens;
        emit PropertyListed(propertyCount, _name, _price, msg.sender);
    }

}
