// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NftMint is ERC721Enumerable,Ownable{

    using Strings for uint256;

    string public baseURI;
    string public baseExtension = ".json";
    uint256 public  cost = 0.0001 ether;
    uint256 public immutable maxSupply;
    bool public paused = false;
    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI,
        uint256 _maxSupply,
        uint256 _initialMint
    ) ERC721(_name,_symbol) Ownable(_msgSender()) {
        setBaseURI(_initBaseURI);
        maxSupply = _maxSupply;

        uint256 initialMint = _initialMint;
        require(initialMint <= maxSupply, "Exceeds max supply");
        for (uint256 i = 0; i < initialMint; i++) {
            _safeMint(msg.sender, totalSupply() + 1);
        }
    }
    function _baseURI() internal view override returns(string memory) {
        return baseURI;
    }

    function mint(address _to, uint256 _mintAmount) public  payable {
        uint256 supply = totalSupply();
        require(_mintAmount > 0);
        require(supply  + _mintAmount <= maxSupply);
        require(!paused, "Contract is paused");
        if (msg.sender != owner()) {
            require(msg.value >= cost * _mintAmount, "Insufficient funds");
        }
        for(uint256 i = 0; i < _mintAmount; i++) {
            _safeMint(_to, supply + i + 1);
        }
    }
    function walletOfOwner(address _owner) public  view returns(uint256[] memory) {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for(uint i=0; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }
    function tokenURI(uint256 tokenId) public view virtual override returns(string memory) {
        require(_ownerOf(tokenId) != address(0), "URI query for nonexistent token");

        string memory currentBaseURI = _baseURI();

        return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
    }
    function withdraw() public onlyOwner {
    (bool success, ) = payable(owner()).call{value: address(this).balance}("");
    require(success, "Withdraw failed");
}
    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }
    function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
        baseExtension = _newBaseExtension;
    }
    function pauseContract(bool _choice) public onlyOwner {
        paused = _choice;
    }
}