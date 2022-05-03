// cryptozombies chapter5
pragma solidity ^0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";

/// @title ゾンビ所有権の移転を管理するコントラクト
/// @author masaya.nakamura
/// @dev OpenZeppelinのERC721ドラフト実装に準拠
contract ZombieOwnership is ZombieAttack, ERC721 {
  // addressを受け取り、そのaddressのトークン保有量を返す
  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return zombieToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
      ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
      ownerZombieCount[_from]--;
      zombieToOwner[_tokenId] = _to;
      Transfer(_from, _to, _tokenId);
  }

  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    zombieApprovals[_tokenId] = _to;
    Approval(msg.sender, _to, _tokenId);
  }

  function takeOwnership(uint256 _tokenId) public {
    require(zombieApprovals[_tokenId] == msg.sender);
    address owner = ownerOf(_tokenId);
    _transfer(owner, msg.sender, _tokenId);
  }
}
