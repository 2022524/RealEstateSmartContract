// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Smart Contract for Real Estate Transactions
contract RealEstateSmartContract {
    // Struct to define a property and its attributes
    struct Property {
        uint id; // Unique ID for the property 
        string name; // Name of property
        uint price; // Total price of property
        address owner; // Owners address
        uint totalTokens; // Number of total tokens in a property
        uint tokensAvailable; // Tokens available for purchase
        mapping(address => uint) tokenHolders; // Mapping of token holders to the number of tokens they own
    }

    // Counting property ID
    uint public propertyCount = 0;
    // Mapping to store properties by the ID 
    mapping(uint => Property) public properties;

    // Event to log a property that is listed
    event PropertyListed(uint propertyId, string name, uint price, address owner);
    // Event to log when tokens are purchsed for a property
    event TokensPurchased(uint propertyId, address buyer, uint tokens);
    // Event to log when property ownership is transferred
    event OwnershipTransferred(uint propertyId, address previousOwner, address newOwner);

    // Modifier to restrict access to functions for only the property owner
    modifier onlyOwner(uint propertyId) {
        require(msg.sender == properties[propertyId].owner, "Not the property owner");
        _;
    }

    // Function will create a new property listed
    function listProperty(string memory _name, uint _price, uint _totalTokens) public{

        // Ensure the price and token count are valid
        require(_price > 0, "The price mst be more than 0");
        require(_totalTokens > 0, "The total number of tokens must be more than 0");

        // Increase the property ID counter
        propertyCount++;
        // Create a new property and store it in the mapping
        Property storage newProperty = properties[propertyCount];
        newProperty.id = propertyCount;
        newProperty.name = _name;
        newProperty.price = _price;
        newProperty.owner = msg.sender; // Set caller as the property owner
        newProperty.totalTokens = _totalTokens;
        newProperty.tokensAvailable = _totalTokens;

        // Emit an event to log the listing of the property
        emit PropertyListed(propertyCount, _name, _price, msg.sender);
    }

    // Function will allow tokens to be purchased for fractional ownership
    function purchaseTokens(uint propertyId, uint tokens) public payable {

        // Fetch the property using the ID
        Property storage property = properties[propertyId];

        // Validate the purchase conditions
        require(property.id > 0, "The Property does not exist");
        require(tokens > 0, "You must purchase at least one token");
        require(tokens <= property.tokensAvailable, "Not enough tokens available");
        require(msg.value == (property.price * tokens) / property.totalTokens, "Incorrect payment amount");

        // Update the buyer's token balance and reduce the available tokens
        property.tokenHolders[msg.sender] += tokens;
        property.tokensAvailable -= tokens;

        // Emit an event to log the token purchased
        emit TokensPurchased(propertyId, msg.sender, tokens);
    }

    // Function will allow for transfering ownership of property
    function transferOwnership(uint256 propertyId, address newOwner) public onlyOwner(propertyId) {
        // Ensure the address of the new owner is valid
        require(newOwner != address(0), "New owner cannot be the 0 address");

        // Update ownership
        address previousOwner = properties[propertyId].owner;
        properties[propertyId].owner = newOwner;

        // Emit an event to log the ownership transfer
        emit OwnershipTransferred(propertyId, previousOwner, newOwner);
    }

    // Function will get the remaining tokens for a property
    function getTokensAvailable(uint propertyId) public view returns (uint) {
        return properties[propertyId].tokensAvailable;
    }

    // Function will withdraw funds for owner
    function withdrawFunds() public {
        payable(msg.sender).transfer(address(this).balance);
    }

    // Function will get token balance of a specific address for a property
    function getTokenBalance(uint256 propertyId, address tokenHolder) public view returns (uint256) {
        return properties[propertyId].tokenHolders[tokenHolder];
    }
}
