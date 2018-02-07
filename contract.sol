pragma solidity ^0.4.19;

contract CatFactory {
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
  //Function syntax as follows, NB the _ before non-global variables
  //Functions are public by default, make them private if there is vulnerability concern
  //private functions can only be invokes by other functions within contract
  //it's conventional to start private functions with an _
  function _createCat(string _name, uint _dna) private {
    cats.push(Cat(_name, _dna));
  }
  //Types of functions: (keyword goes after public/private declaration)
  //view => do not change the shape of the contract state
  //pure => does not access any data in the contract state
  function _generateRandomDna(string _str) private view returns (uint) {
    
  }

}
