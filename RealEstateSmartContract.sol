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
    uint public propertyCount = 0;
    mapping(uint -> Property) public properties;

    event PropertyListed(uint propertyId, string name, uint price, address owner);
    event TokenPurchased(uint propertyId, address buyer, uint tokens);
    event Ownershiptransferred(uint propertyId, address previousOwner, address newOwner);

}