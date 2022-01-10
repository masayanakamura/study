// cryptozombies chapter2
pragma solidity ^0.4.19;

import "./zombiefactory.sol";
// クリプトキティーズインターフェース
// ブロックチェーン上の他人のコントラクトとやりとりするために定義する
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

// ZombieFactoryの継承コントラクト
contract ZombieFeeding is ZombieFactory {

  // クリプトキティーズのアドレス
  KittyInterface kittyContract;

  /***********************
   * クリプトキティーズsetter関数
   * _address   : 捕食者情報
   ***********************/
  function setKittyContractAddress(address _address) external onlyOwner{
    kittyContract = KittyInterface(_address);
  }

  /***********************
   * クールダウン関数
   * _zombie   : ゾンビポインタ
   ***********************/
  function _triggerCooldown(Zombie storage _zombie) internal {
      _zombie.readyTime = uint32(now + cooldownTime);
  }

  /***********************
   * ゾンビ待機状態関数
   * _zombie   : ゾンビポインタ
   ***********************/
  function _isReady(Zombie storage _zombie) internal view returns (bool) {
      return (_zombie.readyTime <= now);
  }

  /***********************
   * 捕食関数
   * _zombieId   : 捕食者情報
   * _targetDna  : 獲物情報
   * _species    : 特徴
   ***********************/
  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal {
    // 呼び出し元が自分のゾンビIDと一致するか判定する
    // msg.senderはグローバル変数で関数を呼び出したユーザー
    // またはスマートコントラクトのaddressを参照できる
    require(msg.sender == zombieToOwner[_zombieId]);

    Zombie storage myZombie = zombies[_zombieId];
    // ゾンビ状態チェック
    require(_isReady(myZombie));

    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if(keccak256(_species)==keccak256("kitty")){
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
    _triggerCooldown(myZombie);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}
