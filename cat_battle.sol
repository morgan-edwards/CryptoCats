pragma solidity ^0.4.19;

import "./cat_helper.sol";

contract CatBattle is CatHelper {
  //nonce is a number only used once
  uint randNonce = 0;
  uint attackVictoryProbability = 70;
  //The following is not a secure random number generator
  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }
  //Grab storage pointers to interact with cats more easily
  function attack(uint _catId, uint _targetId) external {
    Cat storage myCat = cats[_catId];
    Cat storage enemyCat = cats[_targetId];
    uint rand = randMod(100);
    if (rand <= attackVictoryProbability) {
      myCat.winCount++;
      myCat.level++;
      enemyCat.lossCount++;
      feedAndMultiply(_catId, enemyCat.dna, "cat");
    } else {
      myCat.lossCount++;
      enemyCat.winCount++;
    }
    _triggerCooldown(myCat); //defined to be called on a storage struct
  }
}
