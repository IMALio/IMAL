// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ImalContrat {
    address payable public owner;
    struct Leash {
        address owner;
        string typeOfLeash;
        uint256 price;
        bool sold;
    }
    string[] public h3IdsForSale;
    Leash[] public leashes;

    event LeashPurchased(
        uint256 indexed leashId,
        address indexed newOwner,
        address indexed oldOwner,
        uint256 price
    );

    event ParcelSold(
        string indexed h3Id,
        address indexed buyer,
        uint256 salePrice
    );

    constructor() {
        owner = payable(msg.sender);
        // Create 3 types of leashes
        addLeash("Type 1 Leash", 4 ether);
        addLeash("Type 2 Leash", 9 ether);
        addLeash("Type 3 Leash", 16 ether);
    }

    // Buy the 'imal' token
    function buyimal() public payable {
    require(msg.value > 0, "Invalid purchase amount");
    payable(owner).transfer(msg.value);
    }

    
    
    // Only the owner of the leash can call this function
    modifier onlyOwner(uint256 _leashId) {
        require(
            msg.sender == leashes[_leashId].owner,
            "You are not the owner of this leash."
        );
        _;
    }

    // Buy a parcel of land with the specified H3 ID
    function buyParcel(string memory _h3Id) external payable {
        require(msg.value > 0, "Invalid purchase amount");
        uint256 salePrice = msg.value;
        emit ParcelSold(_h3Id, msg.sender, salePrice);
        payable(owner).transfer(msg.value);
    }

    // Repair a leash
    function repairLeash() external payable {
        require(msg.value > 0, "Invalid purchase amount");
        payable(owner).transfer(msg.value);
    }

    // Add a new leash with the specified type and price
    function addLeash(string memory _type, uint256 _price) private {
        Leash memory newLeash = Leash({
            owner: address(0),
            typeOfLeash: _type,
            price: _price,
            sold: false
        });
        leashes.push(newLeash);
    }

    // Purchase the leash with the specified ID
    function purchaseLeash(uint256 _leashId) public payable {
        require(
            _leashId >= 0 && _leashId < leashes.length,
            "Leash does not exist."
        );
        require(msg.value == leashes[_leashId].price, "Insufficient payment.");

        address oldOwner = leashes[_leashId].owner;
        leashes[_leashId].owner = payable(msg.sender);
        leashes[_leashId].sold = true;

        emit LeashPurchased(
            _leashId,
            msg.sender,
            oldOwner,
            leashes[_leashId].price
        );

        payable(owner).transfer(msg.value);
    }

    // Get the current owner of the leash with the specified ID
    function getLeashOwner(uint256 _leashId) public view returns (address) {
        return leashes[_leashId].owner;
    }

    // Get the list of H3 IDs for parcels of land that are for sale
    function getH3IdsForSale() external view returns (string[] memory) {
        return h3IdsForSale;
    }

    // Add a new leash
    function addLeashOfType(string memory _type, uint256 _price) public {
        addLeash(_type, _price);
    }
}