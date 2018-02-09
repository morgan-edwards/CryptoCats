pragma solidity ^0.4.19;

contract CatFactory {

  //Declare any events up here
  event NewCat(uint id, string name, uint dna);
  //unint => unsigned intergers, non-negative, default uint256
  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  //structs are like mini-classes with no logic
  struct Cat {
    string name;
    uint dna;
  }
  //Arrays can be dyanmic [] or fixed [5]
  //when a variable is declared public, a getter is automatically assigned syntax example:
  //Cat[] public cats => an array named cats full of objects with type Cat
  Cat[] public cats;
  //mappings are hashmap key-value pairs
  mapping (uint => address) public catToOwner;
  mapping (address => uint) ownerToCatCount;
  //Function syntax as follows, NB the _ before non-global variables
  //Functions are public by default, make them private if there is vulnerability concern
  //private functions can only be invokes by other functions within contract
  //it's conventional to start private functions with an _
  function _createCat(string _name, uint _dna) private {
    uint id = cats.push(Cat(_name, _dna)) - 1;
    //fire the event
    NewCat(id, _name, _dna);
    //Front-end could listen to the event like this:
    //ContractObject.NewCat((error, result) => {SOME STUFF})
  }
  //Types of functions: (keyword goes after public/private declaration)
  //view => do not change the shape of the contract state
  //pure => does not access any data in the contract state
  //function below integrates typecasting
  function _generateRandomDna(string _str) private view returns (uint) {
    uint rand = uint(keccak256(_str)); //keccak256 is sol's version of SHA256
    return rand % dnaModulus;
  }
  //Bringing all these private helper functions together into public API
  function createRandomCat(string _name) public {
    uint randDna = _generateRandomDna(_name);
    _createCat(_name, randDna);
  }

}
