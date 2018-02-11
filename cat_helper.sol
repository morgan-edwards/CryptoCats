pragma solidity ^0.4.19;

import "./cat_feeding.sol";

contract CatHelper is CatFeeding {

  uint levelUpFee = 0.001 ether;
  //NB modifiers can also take arguments
  modifier aboveLevel(uint _level, uint _catId) {
    require(cats[_catId].level >= _level);
  }
  //functions that receive ether must be marked payable
  function levelUp(uint _catId) external payable {
    require(msg.value == levelUpFee);
    cats[_catId].level++;
  }
  //you must build in functions to remove balance from contract
  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }
  //future-proof the SC with fee setting functions
  function setLevelUpFee(uint _fee) external ownerOnly {
    levelUpFee = _fee;
  }

  function changeName(uint _catId, string _newName) external aboveLevel(2, _catId) ownerOf(_catId){
    cats[_catId].name = _newName;
  }

  function changeDna(uint _catId, uint _newDna) external aboveLevel(20, _catId) ownerOf(_catId){
    cats[_catId].dna = _newDna;
  }
  //externally invoked view functions do not cost any gas
  function getCatsByOwner(address _owner) external view returns(uint[]) {
    //specify memory when declaring variables to avoid expensive storage variables
    //arrays in memory are static length
    uint[] memory result = new uint[](ownerToCatCount[_cat]); //sets length of array
    //because storage is so expensive, it's more efficient to run a for loop everytime
    uint counter = 0;
    for (uint i = 0; i < cats.length; i++) {
      if (catToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
