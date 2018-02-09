//Accessing a smart contract
const abi = null;//ABI provided by compiler
const CatFactoryContract = web3.eth.contract(abi);
const contractAddress = null;//contract address known after deployment
const CatFactory = CatFactoryContract.at(contractAddress);
//CatFactory has access to our contract's public functions and events
//Event listener that will take a text input:
$("#buttonId").click((e) => {
  const name = $("#inputId").val();
  CatFactory.createRandomCat(name);
});
//Listen for the "NewCat" Event to update UI
const event = CatFactory.NewCat((err, res) => {
  if (err) return;
  generateCat(res.catId, res.name, res.dna);
});

//Update UI with new cat:
const generateCat = (id, name, dna) => {
  const dnaStr = String(dna);
  while (dnaStr.length < 16) {
    dnaStr = "0" + dnaStr;
  }

  //first 2 digits make up the breed. There are 7 possible breed choices.
  //to get 1-7, we add 1 then load imagefiles associated with the number
  const catDetails = {
    breedChoice: dnaStr.substring(0, 2) % 7 + 1,
    eyeChoice: dnaStr.substring(2, 4) % 11 + 1,
    shirtChoice: dnaStr.substring(4, 6) % 6 + 1,
    //The last 6 digits adjust CSS hue-rotate, which has 360 degrees
    furColorChoice: parseInt(dnaStr.substring(6, 8) / 100 * 360),
    eyeColorChoice: parseInt(dnaStr.substring(6, 8) / 100 * 360),
    collarColorChoice: parseInt(dnaStr.substring(6, 8) / 100 * 360),
    catName: name,
    catDescription: "A 3rd tier cat",
  };

  return catDetails;
};
