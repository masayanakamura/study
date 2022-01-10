pragma solidity ^0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {


  /***********************
   * レベル比較修飾子
   * _level    : 機能付与レベル
   * _zombieId : 捕食者情報
   ***********************/
  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  /***********************
   * ゾンビ名変更機能
   * _zombieId   : 捕食者情報
   * _newName    : 変更名
   ***********************/
  function changeName(uint _zombieId, string _newName) external aboveLevel(2,_zombieId) {
      require (msg.sender == zombieToOwner[_zombieId]);
      zombies[_zombieId].name = _newName;
  }

  /***********************
   * ゾンビ名変更機能
   * _zombieId   : 捕食者情報
   * _newDna     : 変更DNA
   ***********************/
  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20,_zombieId) {
      require (msg.sender == zombieToOwner[_zombieId]);
      zombies[_zombieId].dna = _newDna;
  }

  /***********************
   * ゾンビ軍団get関数
   * _owner   : オーナーアドレス
   ***********************/
  function getZombiesByOwner(address _owner) external view returns (uint[]) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for(uinti = 0; i < zombies.length; i ++){
        if(zombieToOwner[i] == _owner) {
            result[counter] = i;
            counter++;
        }
    }
    return result;
  }

}
