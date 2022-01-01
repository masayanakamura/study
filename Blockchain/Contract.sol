// cryptozombies chapter1
// https://share.cryptozombies.io/jp/lesson/1/share/yanae?id=Y3p8MTY0MTU1
pragma solidity ^0.4.19;

contract ZombieFactory {

    // イベントをここで宣言するのだ
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        // ここでイベントを発生させるのだ
        NewZombie(id, _name, _dna);

    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
