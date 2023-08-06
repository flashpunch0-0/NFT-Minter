// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/utils/Strings.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage{
    //magic given to us by openzeppelin to help up keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

//svg ka code
    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
  // So, we make a baseSvg variable here that all our NFTs can use.
  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";


     // I create three arrays, each with their own theme of random words.
  // Pick some random funny words, names of anime characters, foods you like, whatever! 
  string[] firstWords = ["hagemaru", "doraemon", "shinchan", "pokemon", "chotabheem", "motupatlu","jujutsu","dragonball","inazuma","oggy","tom&jerry","kitsuke"];
  string[] secondWords = ["paneer","schezwan","roti","capsicum","chilli","asafoetida","brinjal","bhindi","redchilli","mint","tulsi"];
  string[] thirdWords = ["mad","crazy","insane","spooky","gheutak","sutiya"];

event NewEpicNFTMinted(address sender, uint256 tokenId);

    //we need to pass the name of our nfts token and its symbol.
    constructor() ERC721 ("SquareNFT", "SQUARE"){
        console.log("this is my NFT contract.woah!");
    }


//function for random words and random
    function pickRandomFirstWord(uint256 tokenId) public view returns(string memory){
      //random generator
      uint256 rangen = random(string(abi.encodePacked("FIRST_WORD",Strings.toString(tokenId))));
      // Squash the # between 0 and the length of the array to avoid going out of bounds.
      rangen = rangen % firstWords.length;
      return firstWords[rangen];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
      uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
      rand = rand % thirdWords.length;
      return thirdWords[rand];
    }
    function random(string memory input) internal pure returns(uint256){
      return uint256(keccak256(abi.encodePacked(input)));
    }



    function makeAnEpicNFT() public{
        uint256 newItemId = _tokenIds.current();

        //function calls
        // We go and randomly grab one word from each of the three arrays.
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first,second,third));

        //stroing random words
        string memory finalSvg = string(abi.encodePacked(baseSvg,combinedWord,"</text></svg>"));
        
        // :) get all json metadata in place and base64 encode it 
        string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );
    //getting all finsishes here
     // Just like before, we prepend data:application/json;base64, to our data.
      string memory finalTokenUri = string(abi.encodePacked("data:application/json;base64,",json));

        console.log("\n-------------");

        console.log(finalTokenUri);
        console.log("----------------\n");

        //actually mint nft to the sender using msg.sender
        _safeMint(msg.sender, newItemId);
        
        // Return the NFT's metadata
        // tokenURI(newItemId);

        //update your uri
        _setTokenURI(newItemId, finalTokenUri);

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
        console.log("an NFT w/ ID %s has been minter to %s",newItemId,msg.sender);


        emit NewEpicNFTMinted(msg.sender, newItemId);
    }

 
}

