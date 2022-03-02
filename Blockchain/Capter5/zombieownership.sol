// cryptozombies chapter5
pragma solidity ^0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";

//トークン
contract ZombieOwnership is ZombieAttack, ERC721 {
  function balanceOf(address _owner) public view returns (uint256 _balance) {
    // 1.ここで`_owner`がもつゾンビの数を返すのだ
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    // 2. `_tokenId`の所有者をここで返すのだ
    return zombieToOwner[_tokenId];
  }

  function transfer(address _to, uint256 _tokenId) public {

  }

  function approve(address _to, uint256 _tokenId) public {

  }
  
  function takeOwnership(uint256 _tokenId) public {

  }
}
