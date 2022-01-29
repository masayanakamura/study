// cryptozombies chapter2
// https://share.cryptozombies.io/jp/lesson/1/share/yanae?id=Y3p8MTY0MTU1
pragma solidity ^0.4.19;

import "./ownable.sol"

// イーサリアム上にデプロイするとイミュータブルになりあとで修正できない
// SolidityライブラリOpenZeppelinのOwnableコントラクトを継承
// オーナー以外に修正させないため
contract ZombieFactory is Ownable {

    // イベントリスナー。jsのイベントを待つ
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    // ゾンビ保有ステータス
    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Zombie[] public zombies;

    // マッピング宣言 key => value
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    /***********************
     * ゾンビ新規作成
     * _name : ゾンビ名
     * _dna  : 遺伝子情報
     ***********************/
    function _createZombie(string _name, uint _dna) internal {

        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, _dna);
    }

    /***********************
     * 乱数取得
     * _str : ゾンビ名
     ***********************/
    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    /**********************
     * ゾンビ名からランダムにゾンビを作成
     * _str : ゾンビ名
     ***********************/
    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }
}
