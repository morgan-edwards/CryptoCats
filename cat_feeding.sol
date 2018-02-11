pragma solidity ^0.4.19;
//syntax for importing
import "./cat_contract.sol";

// Cats eat their young, which live in another contract, to get the kitten DNA we must
// interface with that smart contract
contract KittyInterface { //is also Ownable through inheritence
  //functions in solidity can return multiple values
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

contract CatFeeding is CatFactory {
  //this creates a KittyInterface named kittyContract and initializes it with the
  //proper address
  KittyInterface kittyContract;

  //modifier created for common logic
  modifier ownerOf(uint _catId) {
    require(msg.sender == catToOwner[_catId]);
    _;
  }

  //Because SCs are immutable, addresses will be replaced to update code, so hardcoding
  //addresses should be avoided, and setter methods should be implemented.
  function setKittyContractAddress(address _address) external onlyOwner { //onlyOwner modifier invoked
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Cat storage _cat) internal { //calling a storage struct passes a ref to that object
      _zombie.readyTime = uint32(now + coolDownTime);
  }

  function _isReady(Zombie storage _zombie) internal view returns (bool) {
    return (_zombieId.readyTime <= now);
  }

  function _feedAndMultiply(uint _catId, uint _targetDna, string _species) internal ownerOf(_catId) {
    // when dealing with an array or struct you must declare whether you want
    // storage => mutates the actual state of the contract, or
    // memory => temporarily held during the execution of the function
    Cat storage myCat = cats[_catId];
    require(_isReady(myCat)); //make sure cat has cooled down long enough
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myCat.dna + _targetDna) / 2;
    //no direct comparison of strings in solidity, so you hash them first
    if (keccak256(_species) == keccak256("kitty")) {
      newDna = newDna - (newDna % 100) + 99; //makes the last two digits 99 for cat
    }
    _createCat("NoName", newDna);
    _triggerCooldown(myCat); //reset cooldown time.
  }

  //this is how you actually call an outside contract, note the commas to handle multiple returns
  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}
