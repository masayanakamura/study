pragma solidity ^0.4.19;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  /***********************
   * 乱数生成関数(keccak256での生成は脆弱性有)
   * _modulus : 乱数幅
   ***********************/
  function randMod(uint _modulus) internal returns (uint){
    randNonce = randNonce.add(1);
    return  uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }

  /***********************
   * 攻撃関数
   * _zombieId : 捕食者情報
   * _targetId : 敵情報
   ***********************/
  function attack(uint _zombieId , uint _targetId) external ownerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = randMod(100);

    if (rand <= attackVictoryProbability) {
      myZombie.winCount = myZombie.winCount.add(1);
      myZombie.level = myZombie.level.add(1);
      enemyZombie.lossCount = enemyZombie.lossCount.add(1);
      feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
    } else {
      myZombie.lossCount = myZombie.lossCount.add(1);
      enemyZombie.winCount = enemyZombie.winCount.add(1);
    }
    _triggerCooldown(myZombie);
  }
}
